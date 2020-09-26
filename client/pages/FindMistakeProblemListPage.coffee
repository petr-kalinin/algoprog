React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FindMistakeList from '../components/FindMistakeList'
import Sceleton from '../components/Sceleton'

import ConnectedComponent from '../lib/ConnectedComponent'

class FindMistakeProblemListPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        path = @props.data?.path.slice(0)
        path.push
            _id: @props.data._id
            title: @props.data.title
        sceletonProps = {
            @props...,
            location: {title: "Найди ошибку", path, _id: "findMistakeProblem"}
        }
        `<Sceleton {...sceletonProps}><FindMistakeList problem={this.props.match.params.problemId}/></Sceleton>`

options =
    urls: (props) ->
        data: "material/#{props.match.params.problemId}"

export default ConnectedComponent(FindMistakeProblemListPage, options)