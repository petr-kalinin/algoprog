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

import * as actions from '../redux/actions'

import styles from './SubmitList.css'

OpenSubmit = (props) ->
    <Modal show={true} onHide={props.close} dialogClassName={styles.modal}>
        <Modal.Body>
            <Tabs defaultActiveKey={1} id="submitTabs">
                <Tab eventKey={1} title="Исходный код">
                    <pre dangerouslySetInnerHTML={{__html: props.submit.source}}></pre>
                </Tab>
                <Tab eventKey={2} title="Комментарии">
                    {
                    res = []
                    a = (el) -> res.push(el)
                    for comment, index in props.submit.comments
                        a <pre key={index} dangerouslySetInnerHTML={{__html: comment}}></pre>
                    res}
                </Tab>
                <Tab eventKey={3} title="Результаты">
                    <h4>Вывод компилятора</h4>
                    <pre dangerouslySetInnerHTML={{__html: props.submit.results.compiler_output}}></pre>
                    <Table striped bordered condensed hover responsive>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Результат</th>
                                <th>Время</th>
                                <th>Память</th>
                            </tr>
                        </thead>
                        <tbody>
                            {
                            res = []
                            a = (el) -> res.push(el)
                            for index, result of props.submit.results.tests
                                a <tr key={index}>
                                    <td>{index}</td>
                                    <td>{result.string_status}</td>
                                    <td>{result.time/1000}</td>
                                    <td>{result.max_memory_used}</td>
                                </tr>
                            res}
                        </tbody>
                    </Table>
                </Tab>
            </Tabs>
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
        () =>
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
                            if submit.outcome == "AC"
                                cl = "success"
                            else if submit.outcome == "IG"
                                cl = "info"
                            else if submit.outcome == "OK"
                                cl = "warning"
                            <tr key={submit._id} className={cl}>
                                <td>{moment(submit.time).format('YYYY-MM-DD kk:mm:ss')}</td>
                                <td>{submit.outcome}</td>
                                <td><a onClick={@openSubmit(submit)}>Подробнее</a></td>
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
