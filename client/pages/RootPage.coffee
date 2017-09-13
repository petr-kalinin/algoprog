React = require('react')

import { Grid } from 'react-bootstrap'

import Tree from '../components/Tree'
import Root from '../components/Root'

import ConnectedComponent from './ConnectedComponent'

class RootPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        return
            <Grid fluid>
                <Root tree={@props.tree}/>
            </Grid>


export default ConnectedComponent(RootPage)
