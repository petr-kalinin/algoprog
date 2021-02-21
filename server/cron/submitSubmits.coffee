iconv = require('iconv-lite')

import SubmitProcess from '../models/SubmitProcess'
import Submit from '../models/submit'
import User from '../models/user'
import Hash  from '../models/Hash'
import RegisteredUser from '../models/registeredUser'

import getTestSystem from '../../server/testSystems/TestSystemRegistry'
import LANGUAGES from '../../client/lib/languages'

import * as downloadSubmits from '../cron/downloadSubmits'

import setDirty from '../lib/setDirty'
import sleep from '../lib/sleep'
import awaitAll from '../../client/lib/awaitAll'

import logger from '../log'

makeTimeouts = () ->
    timeout = 1000 * 60
    result = []
    while true
        result.push(timeout)
        if timeout > 1000 * 60 * 60
            break
        timeout = timeout * 1.5
    return result

TIMEOUT_BY_ATTEMPT = makeTimeouts()

convert = (source, encoding) ->
    if not source
        return ""
    buf = Buffer.from(source, "latin1")
    return iconv.decode(buf, encoding)

compareSources = (newSource, oldSource) ->
    newEncoded = convert(newSource, "utf8")
    for encoding in ["cp866", "cp1251", "utf8"]
        oldEncoded = convert(oldSource, encoding)
        if oldEncoded == newEncoded
            return true
    return false

submitToTestSystem = (submit, submitProcess) ->
    success = false

    onNewSubmit = (newSubmit) ->
        if not compareSources(newSubmit.sourceRaw, submit.sourceRaw)
            return
        newSubmit.findMistake = submit.findMistake
        await Hash.removeForSubmit(submit._id)
        await Submit.remove({_id: submit._id})
        await SubmitProcess.remove({_id: submit._id})
        logger.info "Successfully submitted pending submit #{submit.user} #{submit.problem} attempt #{submitProcess.attempts}"
        success = true

    testSystem = getTestSystem(submit.testSystemData.system)
    registeredUser = await RegisteredUser.findByKeyWithPassword(submit.user)
    try
        try
            logger.info "Try submitWithObject"
            language = LANGUAGES[submit.language][submit.testSystemData.system]
            if not language
                throw "Unknown language id"
            await testSystem.submitWithObject(registeredUser, submit.problem, {source: submit.sourceRaw, language, testSystemData: submit.testSystemData})
            await sleep(1000)
        finally
            await downloadSubmits.runForUserAndProblem(registeredUser.userKey(), submit.problem, onNewSubmit)
    catch e
        if not success
            throw e
    if not success
        throw "Can not submit, submit did not appear in submit list..."


submitOneSubmit = (submit) ->
    submitProcess = await SubmitProcess.findById(submit._id)
    if not submitProcess
        submitProcess = new SubmitProcess
            _id: submit._id
            attempts: 0
            lastAttempt: new Date() - 1000 * 1000 * 1000
        await submitProcess.upsert()

    if submitProcess.attempts >= TIMEOUT_BY_ATTEMPT.length
        needTimeout = TIMEOUT_BY_ATTEMPT[TIMEOUT_BY_ATTEMPT.length - 1]
    else
        needTimeout = TIMEOUT_BY_ATTEMPT[submitProcess.attempts]
    if new Date() - submitProcess.lastAttempt < needTimeout
        return

    logger.info "Try submit pending submit #{submit.user} #{submit.problem} attempt #{submitProcess.attempts}"
    if submit.sourceRaw == "" or not submit.language
        logger.info "Empty source or unknown language, failing"
        submit.outcome = "Ошибка отправки, переотправьте"
        await submit.upsert()
        dirtyResults = {}
        await setDirty(submit, dirtyResults, {})
        await User.updateUser(submit.user, dirtyResults)
        return

    try
        await submitToTestSystem(submit, submitProcess)
    catch e
        if e.duplicate
            logger.info "Duplicate"
            submit.outcome = "DP"
            await submit.upsert()
            await SubmitProcess.remove({_id: submit._id})
        else if e.badPassword
            logger.info "Bad password"
            submit.outcome = "PW"
            await submit.upsert()
            await SubmitProcess.remove({_id: submit._id})
        else
            logger.info "Can not submit pending submit #{submit.user} #{submit.problem} attempt #{submitProcess.attempts}"
            logger.info e, e.message, e.stack
            submitProcess.attempts += 1
            submitProcess.lastAttempt = new Date()
            await submitProcess.upsert()
        dirtyResults = {}
        await setDirty(submit, dirtyResults, {})
        await User.updateUser(submit.user, dirtyResults)


submitSubmits = () ->
    pendingSubmits = await Submit.findPendingSubmits()
    await awaitAll(pendingSubmits.map(submitOneSubmit))

running_ = false

wrapRunning = (callable) ->
    () ->
        if running_
            logger.info "Already running submitSubmits"
            return
        try
            running_ = true
            await callable()
        finally
            running_ = false

export default wrapRunning(submitSubmits)
