React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import {AllAchieves} from '../components/Achieves'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'

class AchievesPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: LangRaw("all_achieves", @props.lang), _id: "achieves"},
        }
        `<Sceleton {...sceletonProps}><AllAchieves/></Sceleton>`

export default withLang(AchievesPage)