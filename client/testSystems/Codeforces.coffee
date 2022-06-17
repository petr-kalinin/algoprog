React = require('react')
import Alert from 'react-bootstrap/lib/Alert'
import { Link } from 'react-router-dom'

import {LangRaw} from '../lang/lang'

import TestSystem from './TestSystem'

export default class Codeforces extends TestSystem
    constructor: () ->
        super()

    id: () ->
        return "codeforces"

    problemLink: (material, lang) ->
        if material.testSystemData.contest.startsWith("gym")
            href = "https://codeforces.com/#{material.testSystemData.contest}/problem/#{material.testSystemData.problem}"
        else
            href = "https://codeforces.com/problemset/problem/#{material.testSystemData.contest}/#{material.testSystemData.problem}"
        <p><a href={href}>
            {LangRaw("codeforces_problem_link", lang)(material.testSystemData.contest, material.testSystemData.problem)}
        </a></p>

    submitListLink: (submit, lang) ->
        if not submit.testSystemData.username
            return null
        href = "https://codeforces.com/submissions/#{submit.testSystemData.username}/contest/#{submit.testSystemData.contest}"
        <p><a href={href}>
            {LangRaw("codeforces_submits_link", lang)}
        </a></p>

    blockSubmission: (material, me, myUser, lang) ->
        if me?.codeforcesUsername || myUser?.memberHasCf
            return null 
        return <Alert bsStyle="danger">
                    {LangRaw("codeforces_block_submission", lang)(me.informaticsId)}
            </Alert>
