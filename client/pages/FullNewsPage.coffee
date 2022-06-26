React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FullNews from '../components/FullNews'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'
import ConnectedComponent from '../lib/ConnectedComponent'

class FullNewsPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {@props..., location: {title: LangRaw("news", @props.lang), path: @props.news.path, _id: @props.news._id}}
        `<Sceleton {...sceletonProps}><FullNews {...this.props}/></Sceleton>`


options =
    urls: (props) ->
        news: "material/news" + LangRaw("material_suffix", props.lang)

export default withLang(ConnectedComponent(FullNewsPage, options))
