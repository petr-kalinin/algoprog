React = require('react')
moment = require('moment')
FontAwesome = require('react-fontawesome')

import Table from 'react-bootstrap/lib/Table'
import Modal from 'react-bootstrap/lib/Modal'
import Button from 'react-bootstrap/lib/Button'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'

import { Link } from 'react-router-dom'

import {LangRaw} from '../lang/lang'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'
import withLang from '../lib/withLang'
import toUtf8 from '../lib/toUtf8'
import hasCapability, {SEE_FIND_MISTAKES, hasCapabilityForUserList} from '../lib/adminCapabilities'

import getTestSystem from '../testSystems/TestSystemRegistry'

import Submit from './Submit'
import SubmitForm from './SubmitForm'
import SubmitListTable from './SubmitListTable'
import BestSubmits from './BestSubmits'

import styles from './SubmitList.css'

OpenSubmit = withLang (props) ->
    <Modal show={true} onHide={props.close} dialogClassName={styles.modal}>
        <Modal.Body>
            <Submit submit={props.submit}/>
        </Modal.Body>

        <Modal.Footer>
            <Button bsStyle="primary" onClick={props.close}>{LangRaw("close", props.lang)}</Button>
        </Modal.Footer>
    </Modal>

class SubmitList extends React.Component
    constructor: (props) ->
        super(props)
        @state = 
            bestSubmits: false
        @openSubmit = @openSubmit.bind(this)
        @closeSubmit = @closeSubmit.bind(this)
        @toggleBestSubmits = @toggleBestSubmits.bind this

    openSubmit: (submit) ->
        (e) =>
            e.preventDefault()
            @setState
                openSubmit: submit

    closeSubmit: () ->
        @setState
            openSubmit: null

    toggleBestSubmits: (e) ->
        if e
            e.preventDefault()
        @setState
            bestSubmits: not @state.bestSubmits

    componentDidUpdate: (prevProps, prevState) ->
        if not prevProps.data? or not @props.data?
            return
        diff = false
        if prevProps.data.length != @props.data.length
            diff = true
        else
            for i in [0...@props.data.length]
                if prevProps.data[i].outcome != @props.data[i].outcome
                    diff = true
        if diff
            @props.handleReload()

    render:  () ->
        if not @props.myUser?._id
            return null
        testSystem = getTestSystem(@props.material.testSystemData.system)
        blockedByTestSystem = testSystem.blockSubmission(@props.material, @props.me, @props.myUser, @props.lang)
        if blockedByTestSystem
            return blockedByTestSystem
        <div>
            {if @props.noBestSubmits || not @props.findMistake?.pagesCount
                null
            else if @props.result?.solved != 0 || hasCapability(@props.me, SEE_FIND_MISTAKES)
                <h4><Link to="/findMistakeProblem/#{@props.material._id}">{LangRaw("find_mistake", @props.lang)}</Link></h4>
            else if @props.result?.solved == 0
                <h4 className="text-muted"><span title={LangRaw("you_will_be_able_to_find_mistake", @props.lang)}>{LangRaw("find_mistake", @props.lang)} <FontAwesome name="question-circle-o"/></span></h4>
            }
            {if @props.noBestSubmits 
                null
            else if @props.bestSubmits?.length
                <h4><a href="#" onClick={@toggleBestSubmits}>{LangRaw("good_submits", @props.lang)}</a></h4>
            else if @props.result?.solved == 0
                <h4 className="text-muted"><span title={LangRaw("here_will_be_good_submits", @props.lang)}>{LangRaw("good_submits", @props.lang)} <FontAwesome name="question-circle-o"/></span></h4>
            }
            <SubmitForm material={@props.material} 
                problemId={@props.material._id} 
                reloadSubmitList={@props.handleReload} 
                noFile={@props.noFile} 
                canSubmit={@props.canSubmit} 
                findMistake={@props.findMistake} 
                startLanguage={@props.startLanguage || (@props.data?.length && @props.data[@props.data.length-1].language) }
                editorOn={@props.editorOn}
                editorDidMount={@props.editorDidMount}
                editorValue={@props.data?.length && toUtf8(@props.data[@props.data.length-1].sourceRaw || "") || @props.defaultSource}/>
            {
            if @state.openSubmit?._id
                <OpenSubmit submit={@state.openSubmit} close={@closeSubmit}/>
            }
            {
            @state.bestSubmits && <BestSubmits submits={@props.bestSubmits} close={@toggleBestSubmits}/>
            }
            <h4>{LangRaw("attempts", @props.lang)}</h4>
            <p>{LangRaw("do_not_refresh_attempts", @props.lang)}</p>
            {
            if @props.data?.length
                <SubmitListTable submits={@props.data} handleSubmitClick={@openSubmit} />
            else
                <p>{LangRaw("no_attempts_yet", @props.lang)}</p>
            }
        </div>

options =
    urls: (props) ->
        if props?.myUser?._id
            result = {}
            if not props?.noBestSubmits
                result.bestSubmits = "bestSubmits/#{props.material._id}"
                if props.myUser?._id
                    result.findMistake = "findMistakeProblemPages/#{props.myUser._id}/#{props.material._id}"
            return result
        return {}

    wsurls: (props) ->
        if props?.myUser?._id
            result = {}
            if props?.findMistake
                result.data = "submitsForFindMistake/#{props.myUser._id}/#{props.findMistake}"
            else
                result.data = "submits/#{props.myUser._id}/#{props.material._id}"
            if not props?.noBestSubmits
                result.result = "result/#{props.myUser._id}::#{props.material._id}"
            return result
        return {}

    allowNotLoaded: true

export default withLang(withMyUser(ConnectedComponent(SubmitList, options)))