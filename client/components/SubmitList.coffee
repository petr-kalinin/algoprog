React = require('react')
moment = require('moment')

import { connect } from 'react-redux'
import { Link } from 'react-router-dom'
import { CometSpinLoader } from 'react-css-loaders'
import Table from 'react-bootstrap/lib/Table'

import * as actions from '../redux/actions'

class SubmitList extends React.Component
    constructor: (props) ->
        super(props)
        @handleReload = @handleReload.bind(this)

    url: () ->
        if @props?.myUser?._id
            "submits/#{@props.myUser._id}/#{@props.material._id}"

    render:  () ->
        if @dataOutdated()
            <CometSpinLoader />
        else if @props.submits?.length
            <Table responsive striped condensed hover>
                <thead>
                    <tr>
                        <th>Время</th>
                        <th>Результат</th>
                     </tr>
                </thead>
                <tbody>
                    {@props.submits && @props.submits.map((submit) ->
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
                        </tr>
                    ).reverse()}
                </tbody>
            </Table>
        else
            <p>Посылок по этой задаче еще не было</p>

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
            await Promise.all(@requestData())
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
