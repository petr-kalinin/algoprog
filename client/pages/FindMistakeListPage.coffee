React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FindMistakeList from '../components/FindMistakeList'
import Sceleton from '../components/Sceleton'

import {LangRaw} from '../lang/lang'
import withLang from '../lib/withLang'


class FindMistakeListPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: LangRaw("find_mistake", @props.lang), _id: "findMistake" + LangRaw("material_suffix", @props.lang)},
        }
        `<Sceleton {...sceletonProps}><FindMistakeList allowSort={true}/></Sceleton>`

export default withLang(FindMistakeListPage)