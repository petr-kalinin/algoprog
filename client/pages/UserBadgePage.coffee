React = require('react')

import { Grid } from 'react-bootstrap'
import { Helmet } from "react-helmet"

import UserBadge from '../components/UserBadge'
import callApi from '../lib/callApi'

Explanation =
    <div>
        <h1>Неизвестный пользователь</h1>
        <p>Это может быть ошибкой, а может быть нормально:</p>
        <ul>
            <li>Если вы не занимаетесь в этом курсе, а просто зашли посмотреть, то это нормально.</li>
            <li>Если вы занимаетесь, но не написали мне об этом, то это ошибка, срочно напишите.</li>
            <li>Если вы написали, но не очень давно (менее 2 дней назад), то, возможно, я просто еще не видел вашего письма;</li>
            <li>Если вы еще не решали задач в курсе, то вас пока нет в сводных таблицах и нет здесь. Как только будете решать, эта ошибка пропадет.</li>
            <li>Если вы решали задачи в курсе, но очень давно, и я вас только что добавил в таблицы, то ваши старые результаты появятся в течение суток.</li>
            <li>Иначе срочно напишите мне, возможно, я вас как-то не так добавил.</li>
        </ul>
    </div>

class UserBadgePage extends React.Component
    constructor: (props) ->
        super(props)
        @id = UserBadgePage.getId(props.match)
        @state = props.data || window?.__INITIAL_STATE__ || {}
        @handleReload = @handleReload.bind(this)

    render:  () ->
        if not @state?.user?.name
            return
                <Grid fluid>
                    {Explanation}
                </Grid>
        return
            <Grid fluid>
                <Helmet>
                    <title>{@state.user.name}</title>
                </Helmet>
                <UserBadge user={@state.user} me={@state.me} handleReload={@handleReload} explain={true}/>
            </Grid>

    componentDidMount: ->
        @handleReload()

    handleReload: ->
        data = await UserBadgePage.loadData(@props.match)
        @setState(data)

    @getId: (match) ->
        match.params.id

    @loadData: (match) ->
        user = await callApi 'user/' + UserBadgePage.getId(match)
        me = await callApi 'me'
        return
            user: user
            me: me

export default UserBadgePage
