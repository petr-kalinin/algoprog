React = require('react')
import fetch from 'isomorphic-fetch'

import { Grid } from 'react-bootstrap'
import Dashboard from '../components/Dashboard'
import callApi from '../lib/callApi'

data1 = 
    _id: "aaa",
    user: 
        _id: 123,
        name: "Василий Пупкин",
        userList: "lic40"
        level: "1А"
    table:
        _id: "p456",
        name: "Задача",
        tables: ["1А: таблица", "2Б: таблица"]
    attempts: 10
    lastSubmitTime: new Date(2017, 4, 15, 12, 14, 15)

data2 = 
    _id: "bbb",
    user: 
        _id: 234,
        name: "Василий Пупкин2",
        userList: "stud"
        level: "1Б"
    table:
        _id: "p4567",
        name: "Задача2",
        tables: ["1А: таблица2", "2Б: таблица2"]
    attempts: 10
    lastSubmitTime: new Date(2017, 4, 15, 12, 14, 16)
    
data = 
    ok: [data1, data2],
    wa: [],
    ig: [data1],
    ac: [data2]

class DashboardPage extends React.Component 
    constructor: (props) ->
        super(props)
        @state = props.data || window.__INITIAL_STATE__ || {}
        
    render:  () ->
        return 
            <Grid fluid>
                {`<Dashboard {...this.state}/>`}
            </Grid>
            
    componentDidMount: ->
        data = await DashboardPage.loadData(@props.match)
        @setState(data)
        
    @loadData: (match) ->
        return data
        #callApi 'user/' + UserBadgePage.getId(match)

export default DashboardPage 
