React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import AllComments from '../components/AllComments'
import Sceleton from '../components/Sceleton'

export default class AllCommentsPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Комментарии", _id: "achieves"},
        }
        `<Sceleton {...sceletonProps}><AllComments/></Sceleton>`

