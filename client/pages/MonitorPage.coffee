React = require('react')

import Monitor from '../components/Monitor'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

makePath = (contest) ->
    [{title: contest.name, _id: contest._id, href: "/contest/#{contest._id}"}
    {title: "Результаты", _id: contest._id + "m", href: "/monitor/#{contest._id}"}]

class MonitorPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {@props..., location: {title: @props.contest?.name, path: makePath(@props.contest), _id: @props.contest?._id + "m"}}
        `<Sceleton {...sceletonProps}><Monitor {...this.props} contest={this.props.contest} monitor={this.props.monitor}/></Sceleton>`

options =
    urls: (props) ->
        contest: "contest/#{props.match.params.id}"
        monitor: "monitor/#{props.match.params.id}"

export default ConnectedComponent(MonitorPage, options)
