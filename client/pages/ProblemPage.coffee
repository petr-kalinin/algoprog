React = require('react')

import Problem from '../components/Problem'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

makePath = (contest, problem) ->
    [
        {title: contest.name, _id: contest._id, href: "/contest/#{contest._id}"},
        {title: problem.name, _id: problem._id, href: "/problem/#{contest._id}/#{problem._id}"},
    ]

class ProblemPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {@props..., location: {title: @props.problem?.name, path: makePath(@props.contest, @props.problem), _id: @props.problem?._id}}
        `<Sceleton {...sceletonProps}><Problem {...this.props} material={this.props.problem}/></Sceleton>`

options =
    urls: (props) ->
        contest: "contest/#{props.match.params.contest}"
        problem: "problem/#{props.match.params.contest}/#{props.match.params.id}"

export default ProblemPageConnected = ConnectedComponent(ProblemPage, options)
