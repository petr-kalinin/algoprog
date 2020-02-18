React = require('react')
moment = require('moment')
FontAwesome = require('react-fontawesome')

import Table from 'react-bootstrap/lib/Table'
import Modal from 'react-bootstrap/lib/Modal'
import Button from 'react-bootstrap/lib/Button'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'

import Submit from './Submit'
import SubmitForm from './SubmitForm'
import SubmitListTable from './SubmitListTable'
import BestSubmits from './BestSubmits'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

import outcomeToText from '../lib/outcomeToText'

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
        @state = {bestSubmits: false}
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
        <div>
            {
            ###
            if @props.bestSubmits.length
                <h4><a href="#" onClick={@toggleBestSubmits}>Хорошие решения</a></h4>
            else if @props.result.solved == 0
                <h4 className="text-muted"><span title="Когда вы получите Зачтено, здесь будут хорошие решения">Хорошие решения <FontAwesome name="question-circle-o"/></span></h4>
            ###
            }
            <SubmitForm material={@props.material} problemId={@props.material._id} reloadSubmitList={@props.handleReload}/>
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
            return
                data: "submits/#{props.myUser._id}/#{props.material._id}"
                result: "result/#{props.myUser._id}::#{props.material._id}"
                bestSubmits: "bestSubmits/#{props.material._id}"
        return {}

    timeout: 20 * 1000

export default withMyUser(ConnectedComponent(SubmitList, options))
