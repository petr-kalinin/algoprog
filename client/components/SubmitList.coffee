React = require('react')
moment = require('moment')

import { connect } from 'react-redux'
import { Link } from 'react-router-dom'
import { CometSpinLoader } from 'react-css-loaders'

import Table from 'react-bootstrap/lib/Table'
import Modal from 'react-bootstrap/lib/Modal'
import Button from 'react-bootstrap/lib/Button'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'

import Submit from './Submit'

import * as actions from '../redux/actions'

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
        @state = {}
        @handleReload = @handleReload.bind(this)
        @openSubmit = @openSubmit.bind(this)
        @closeSubmit = @closeSubmit.bind(this)

    url: () ->
        if @props?.myUser?._id
            "submits/#{@props.myUser._id}/#{@props.material._id}"

    openSubmit: (submit) ->
        (e) =>
            e.preventDefault()
            @setState
                openSubmit: submit

    closeSubmit: () ->
        @setState
            openSubmit: null

    render:  () ->
        if not @props.myUser?._id
            return null
        <div>
            {
            if @state.openSubmit?._id
                <OpenSubmit submit={@state.openSubmit} close={@closeSubmit}/>
            }
            <h4>Попытки</h4>
            <p>Не обновляйте страницу; список посылок обновляется автоматически.</p>
            {
            if @dataOutdated()
                <CometSpinLoader />
            else if @props.submits?.length
                <Table responsive striped condensed hover>
                    <thead>
                        <tr>
                            <th>Время</th>
                            <th>Результат</th>
                            <th>&nbsp;</th>
                         </tr>
                    </thead>
                    <tbody>
                        {@props.submits && @props.submits.map((submit) =>
                            cl = undefined
                            message = submit.outcome
                            switch submit.outcome
                                when "AC"
                                    cl = "success"
                                    message = "Зачтено"
                                when "IG"
                                    cl = "info"
                                    message = "Проигнорировано"
                                when "OK"
                                    cl = "warning"
                                when "CE"
                                    message = "Ошибка компиляции"
                                when "DQ"
                                    message = "Дисквалифицировано"
                            <tr key={submit._id} className={cl}>
                                <td>{moment(submit.time).format('YYYY-MM-DD HH:mm:ss')}</td>
                                <td>{message}</td>
                                <td><a onClick={@openSubmit(submit)} href="#">Подробнее</a></td>
                            </tr>
                        ).reverse()}
                    </tbody>
                </Table>
            else
                <p>Посылок по этой задаче еще не было</p>
            }
        </div>

    dataOutdated: () ->
        url = @url()
        if not url
            return false
        if not @props.submits
            return true
        if @props.submitsUrl == url
            return false
        if decodeURIComponent(@props.submitsUrl) == url
            return false
        return true

    componentWillMount: ->
        if not window?
            promises = @requestData()
            @props.saveDataPromises(promises)

    componentDidMount: ->
        @requestDataAndSetTimeout()

    componentDidUpdate: (prevProps, prevState) ->
        if @dataOutdated()
            @requestData()

    componentWillUnmount: ->
        if @timeout
            console.log "Clearing timeout", @url()
            clearTimeout(@timeout)

    requestData: () ->
        promises = []
        if @url()
            promises.push(@props.getSubmits(@url()))
        return promises

    handleReload: () ->
        @requestData()

    requestDataAndSetTimeout: () ->
        try
            await Promise.all([@requestData()])
            console.log "Updated data", @url()
        catch
            console.log "Can't reload data", @url()
        console.log "Setting timeout", @url()
        @timeout = setTimeout((() => @requestDataAndSetTimeout()), 20000)


mapStateToProps = (state, ownProps) ->
    return
        myUser: state.myUser
        submitsUrl: state.submits.url
        submits: state.submits.data

mapDispatchToProps = (dispatch, ownProps) ->
    return
        getSubmits: (url) -> dispatch(actions.getSubmits(url))
        saveDataPromises: (promise) -> dispatch(actions.saveDataPromises(promise))

export default connect(mapStateToProps, mapDispatchToProps)(SubmitList)
