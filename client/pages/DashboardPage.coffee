React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import Dashboard from '../components/Dashboard'
import ConnectedComponent from './ConnectedComponent'

class DashboardPage extends React.Component
    constructor: (props) ->
        super(props)

    @url: () ->
        "dashboard"

    @timeout: () ->
        20000

    render:  () ->
        return
            <Grid fluid>
                <Helmet>
                    <title>Последние результаты</title>
                </Helmet>
                {`<Dashboard {...this.props.data}/>`}
            </Grid>


export default ConnectedComponent(DashboardPage)
