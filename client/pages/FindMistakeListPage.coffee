React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FindMistakeList from '../components/FindMistakeList'
import Sceleton from '../components/Sceleton'

import LANG from '../lang/lang'
import withLang from '../lib/withLang'


class FindMistakeListPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Найди ошибку", _id: "findMistake" + LANG("material_suffix", @props.lang)},
        }
        `<Sceleton {...sceletonProps}><FindMistakeList allowSort={true}/></Sceleton>`

export default withLang(FindMistakeListPage)