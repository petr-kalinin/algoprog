React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FindMistake from '../components/FindMistake'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import ConnectedComponent from '../lib/ConnectedComponent'
import withLang from '../lib/withLang'
import withMyUser from '../lib/withMyUser'

class FindMistakePage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "#{LangRaw('find_mistake', @props.lang)}: #{@props.findMistake?.fullProblem?.name}", _id: "findMistake" + LangRaw("material_suffix", @props.lang)},
        }
        `<Sceleton {...sceletonProps}><FindMistake findMistake={this.props.findMistake}/></Sceleton>`

options =
    urls: (props) ->
        findMistake: "findMistake/#{props.match.params.id}/#{props.myUser?._id}?lang=#{LangRaw("material_suffix", props.lang)}"

export default withLang(withMyUser(ConnectedComponent(FindMistakePage, options)))