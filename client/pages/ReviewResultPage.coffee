React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import ReviewResult from '../components/ReviewResult'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class ReviewResultPage extends React.Component
    constructor: (props) ->
        super(props)

    @urls: (props) ->
        data: "result/#{props.match.params.id}"

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Результат #{@props.match.params.id}", _id: "submit"},
            showNews: "hide",
            showTree: "hide"
        }
        `<Sceleton {...sceletonProps}><ReviewResult result={this.props.data} me={this.props.me}/></Sceleton>`


export default ConnectedComponent(ReviewResultPage)
