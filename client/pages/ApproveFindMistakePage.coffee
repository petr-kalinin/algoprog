React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import ApproveFindMistake from '../components/ApproveFindMistake'
import Sceleton from '../components/Sceleton'

export default class ApproveFindMistakePage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Одобрение поиска ошибок", _id: "achieves"},
            showNews: "hide",
            showTree: "hide"
        }
        `<Sceleton {...sceletonProps}><ApproveFindMistake/></Sceleton>`

