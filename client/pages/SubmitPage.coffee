React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import Submit from '../components/Submit'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class SubmitPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Посылка #{@props.match.params.id}", _id: "submit"},
            showNews: "hide",
            showTree: "hide"
        }
        `<Sceleton {...sceletonProps}><Submit submit={this.props.data}/></Sceleton>`


options =
    url: (props) ->
        data: "submit/#{props.match.params.id}"

export default ConnectedComponent(SubmitPage, options)
