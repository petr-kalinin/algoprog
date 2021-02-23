React = require('react')

import Contest from '../components/Contest'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

makePath = (contest) ->
    [{title: contest.name, _id: contest._id, href: "/contest/#{contest._id}"}]

class ContestPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {@props..., location: {title: @props.contest?.name, path: makePath(@props.contest), _id: @props.contest?._id}}
        `<Sceleton {...sceletonProps}><Contest {...this.props} contest={this.props.contest}/></Sceleton>`

options =
    urls: (props) ->
        contest: "contest/#{props.match.params.id}"

export default ContestPageConnected = ConnectedComponent(ContestPage, options)
