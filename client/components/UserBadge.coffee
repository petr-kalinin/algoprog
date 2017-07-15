React = require('react')

import { Grid } from 'react-bootstrap'

import CfStatus from './CfStatus'

data = 
    user:
        name: "Василий Пупкин",
        level:
            current: "2Б"
        rating: 123,
        activity: 1.45
        cf:
            login: "abc",
            color: "green",
            rating: 1400,
            activity: 3.456,
            progress: 85.123
            

export default class UserBadge extends React.Component 
    render:  () ->
        return 
            <Grid fluid>
                <h1>{data.user.name}</h1>
                <blockquote>
                    <div>Уровень: {data.user.level.current}</div>
                    <div>Рейтинг: {data.user.rating}</div>
                    <div>Активность: {data.user.activity}</div>
                    { data.user.cf?.login && 
                        <div> Codeforces рейтинг: <CfStatus cf={data.user.cf}/> </div> }
                </blockquote>
            </Grid>
