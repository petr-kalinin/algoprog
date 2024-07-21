React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import AllSubmits from '../components/AllSubmits'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import Lang from '../lang/lang'
import withLang from '../lib/withLang'

class AllSubmitsPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: LangRaw("submits_list", @props.lang), _id: "submits_list" + LangRaw("material_suffix", @props.lang)},
        }
        child = <AllSubmits userId={@props.match.params.id} lang={@props.lang}/>
        `<Sceleton {...sceletonProps}>{child}</Sceleton>`

export default withLang(AllSubmitsPage)