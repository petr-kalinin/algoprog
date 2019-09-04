React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import {AllAchieves} from '../components/Achieves'
import Sceleton from '../components/Sceleton'

export default class AchievesPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Все ачивки", _id: "achieves"},
        }
        `<Sceleton {...sceletonProps}><AllAchieves/></Sceleton>`

