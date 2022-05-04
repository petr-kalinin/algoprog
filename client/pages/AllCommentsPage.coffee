React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import AllComments from '../components/AllComments'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'

class AllCommentsPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Комментарии", _id: "comments" + LangRaw("material_suffix", @props.lang)},
        }
        `<Sceleton {...sceletonProps}><AllComments/></Sceleton>`


export default withLang(AllCommentsPage)