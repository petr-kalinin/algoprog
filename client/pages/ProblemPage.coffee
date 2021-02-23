React = require('react')

import Problem from '../components/Problem'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

makePath = (problem) ->
    contest = problem.contests[0]
    [
        {title: contest.name, _id: contest._id, href: "/contest/#{contest._id}"},
        {title: problem.name, _id: problem._id, href: "/problem/#{problem._id}"},
    ]

class ProblemPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {@props..., location: {title: @props.problem?.name, path: makePath(@props.problem), _id: @props.problem?._id}}
        `<Sceleton {...sceletonProps}><Problem {...this.props} material={this.props.problem}/></Sceleton>`

options =
    urls: (props) ->
        problem: "problem/#{props.match.params.id}"

export default ProblemPageConnected = ConnectedComponent(ProblemPage, options)
