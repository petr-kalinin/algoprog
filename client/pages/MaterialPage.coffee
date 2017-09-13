React = require('react')

import { Helmet } from "react-helmet"
import { Grid } from 'react-bootstrap'

import Material from '../components/Material'
import ConnectedComponent from './ConnectedComponent'

class MaterialPage extends React.Component
    constructor: (props) ->
        super(props)

    @url: (params) ->
        return "material/#{params.id}"

    render:  () ->
        <Grid fluid>
            <Helmet>
                {@props.data?.title && <title>{@props.data.title}</title>}
            </Helmet>
            {`<Material {...this.props} material={this.props.data}/>`}
        </Grid>

export default MaterialPageConnected = ConnectedComponent(MaterialPage)
