React = require('react')
moment = require('moment')
FontAwesome = require('react-fontawesome')

import Table from 'react-bootstrap/lib/Table'
import Modal from 'react-bootstrap/lib/Modal'
import Button from 'react-bootstrap/lib/Button'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'

import { Link } from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'
import outcomeToText from '../lib/outcomeToText'

import getTestSystem from '../testSystems/TestSystemRegistry'

import Submit from './Submit'
import SubmitForm from './SubmitForm'
import SubmitListTable from './SubmitListTable'
import BestSubmits from './BestSubmits'

import styles from './SubmitList.css'

OpenSubmit = (props) ->
    <Modal show={true} onHide={props.close} dialogClassName={styles.modal}>
        <Modal.Body>
            <Submit submit={props.submit}/>
        </Modal.Body>

        <Modal.Footer>
            <Button bsStyle="primary" onClick={props.close}>Закрыть</Button>
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

    render:  () ->
        if not @props.myUser?._id
            return null
        testSystem = getTestSystem(@props.material.testSystemData.system)
        blockedByTestSystem = testSystem.blockSubmission(@props.material, @props.me)
        if blockedByTestSystem
            return blockedByTestSystem
        <div>
            {if @props.noBestSubmits || not @props.findMistake?.pagesCount
                null
            else if @props.result?.solved != 0 || @props.me.admin
                <h4><Link to="/findMistakeProblem/#{@props.material._id}">Найди ошибку</Link></h4>
            else if @props.result?.solved == 0
                <h4 className="text-muted"><span title="Когда вы получите Зачтено, здесь вы сможете искать ошибки в чужих решениях">Найди ошибку <FontAwesome name="question-circle-o"/></span></h4>
            }
            {if @props.noBestSubmits 
                null
            else if @props.bestSubmits?.length
                <h4><a href="#" onClick={@toggleBestSubmits}>Хорошие решения</a></h4>
            else if @props.result?.solved == 0
                <h4 className="text-muted"><span title="Когда вы получите Зачтено, здесь будут хорошие решения">Хорошие решения <FontAwesome name="question-circle-o"/></span></h4>
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
                editorValue={@props.data?.length && @props.data[@props.data.length-1].sourceRaw || @props.defaultSource}/>
            {
            if @state.openSubmit?._id
                <OpenSubmit submit={@state.openSubmit} close={@closeSubmit}/>
            }
            {
            @state.bestSubmits && <BestSubmits submits={@props.bestSubmits} close={@toggleBestSubmits}/>
            }
            <h4>Попытки <Button onClick={@props.handleReload}>{"\u200B"}<FontAwesome name="refresh"/></Button></h4>
            <p>Не обновляйте страницу; список посылок обновляется автоматически.</p>
            {
            if @props.data?.length
                <SubmitListTable submits={@props.data} handleSubmitClick={@openSubmit} />
            else
                <p>Посылок по этой задаче еще не было</p>
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

export default withMyUser(ConnectedComponent(SubmitList, options))