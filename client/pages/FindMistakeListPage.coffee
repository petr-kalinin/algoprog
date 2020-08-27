React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FindMistakeList from '../components/FindMistakeList'
import Sceleton from '../components/Sceleton'

export default class FindMistakeListPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Найди ошибку", _id: "findMistake"},
        }
        `<Sceleton {...sceletonProps}><FindMistakeList/></Sceleton>`

