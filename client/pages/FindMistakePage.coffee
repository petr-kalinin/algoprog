React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FindMistake from '../components/FindMistake'
import Sceleton from '../components/Sceleton'

import LANG from '../lang/lang'
import ConnectedComponent from '../lib/ConnectedComponent'
import withLang from '../lib/withLang'
import withMyUser from '../lib/withMyUser'

class FindMistakePage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Найди ошибку: #{@props.findMistake?.fullProblem?.name}", _id: "findMistake" + LANG("material_suffix", @props.lang)},
        }
        `<Sceleton {...sceletonProps}><FindMistake findMistake={this.props.findMistake}/></Sceleton>`

options =
    urls: (props) ->
        findMistake: "findMistake/#{props.match.params.id}/#{props.myUser?._id}"

export default withLang(withMyUser(ConnectedComponent(FindMistakePage, options)))