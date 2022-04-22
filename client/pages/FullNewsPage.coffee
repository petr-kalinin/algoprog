React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FullNews from '../components/FullNews'
import Sceleton from '../components/Sceleton'

import LANG from '../lang/lang'
import withLang from '../lib/withLang'
import ConnectedComponent from '../lib/ConnectedComponent'

class FullNewsPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {@props..., location: {title: LANG("news", @props.lang), path: @props.news.path, _id: @props.news._id}}
        `<Sceleton {...sceletonProps}><FullNews {...this.props}/></Sceleton>`


options =
    urls: (props) ->
        if props.lang == "ru"
            news: "material/news"
        else
            news: "material/news!en"

export default withLang(ConnectedComponent(FullNewsPage, options))
