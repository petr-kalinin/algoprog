React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FindMistake from '../components/FindMistake'
import Sceleton from '../components/Sceleton'

import ConnectedComponent from '../lib/ConnectedComponent'

class FindMistakePage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Найди ошибку: #{@props.findMistake?.fullProblem?.name}", _id: "findMistake"},
        }
        `<Sceleton {...sceletonProps}><FindMistake findMistake={this.props.findMistake}/></Sceleton>`

options =
    urls: (props) ->
        findMistake: "findMistake/#{props.match.params.id}"

export default ConnectedComponent(FindMistakePage, options)