React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import Submit from '../components/Submit'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from './ConnectedComponent'

class SubmitPage extends React.Component
    constructor: (props) ->
        super(props)

    @url: (props) ->
        'submit/' + props.match.params.id

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Посылка #{@props.match.params.id}", _id: "submit"},
            showNews: "hide",
            showTree: "hide"
        }
        `<Sceleton {...sceletonProps}><Submit submit={this.props.data}/></Sceleton>`


export default ConnectedComponent(SubmitPage)
