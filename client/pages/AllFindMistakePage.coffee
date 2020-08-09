React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import {FindMistake} from '../components/FindMistake'
import Sceleton from '../components/Sceleton'

export default class AllFindMistakePage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Найди ошибку", _id: "findMistake"},
        }
        `<Sceleton {...sceletonProps}><FindMistake/></Sceleton>`

