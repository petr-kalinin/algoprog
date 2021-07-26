React = require('react')
moment = require('moment')

import Button from 'react-bootstrap/lib/Button'

import callApi from '../../lib/callApi'

startContest = (contestId, reload) ->
    () ->
        await callApi "startContest/#{contestId}", {}
        reload()

Header = (props) ->
    <div>
        {props.contestResult.startTime && <p>Время начала контеста: {moment(props.contestResult.startTime).format('DD.MM.YY HH:mm:ss')} </p>}
        {props.contestResult.virtualBlocked && 
            <div>
                <p>Этот контест виртуальный: нажмите кнопку, чтобы стартовать контест.</p>
                <Button type="submit" bsStyle="primary" onClick={startContest(props.contest._id, props.handleReload)}>
                    Начать виртуальный контест!
                </Button>
            </div>
        }
    </div>

export default virtual = (cls) ->
    return class WithVirtualHeader extends cls
        Contest: () ->
            Super = super()
            (props) ->
                <div>
                    <Header {props...}/>
                    <Super {props...}/>
                </div>
