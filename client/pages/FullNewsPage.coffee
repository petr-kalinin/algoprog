React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import FullNews from '../components/FullNews'

import ConnectedComponent from './ConnectedComponent'

class FullNewsPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        return
            <Grid fluid>
                <Helmet>
                    <title>Новости</title>
                </Helmet>
                {`<FullNews {...this.props}/>`}
            </Grid>


export default ConnectedComponent(FullNewsPage)
