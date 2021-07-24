React = require('react')
moment = require('moment')

import Button from 'react-bootstrap/lib/Button'

import callApi from '../../lib/callApi'

import blockIf from './blockIf'

shouldBlock = (contestResults) ->
    return not contestResults?.startTime

startContest = (contestId, reload) ->
    () ->
        await callApi "startContest/#{contestId}", {}
        reload()

Message = (props) ->
    <div>
        <p>Этот контест виртуальный: нажмите кнопку, чтобы стартовать контест.</p>
        <Button type="submit" bsStyle="primary" onClick={startContest(props.contest._id, props.handleReload)}>
            Начать виртуальный контест!
        </Button>
    </div>

export default virtual = (cls) ->
    class WithVirtualHeader extends cls
        Contest: () ->
            Super = super()
            (props) ->
                <div>
                    <p>Время начала контеста: {moment(props.contestResult.startTime).format('DD.MM.YY HH:mm:ss')} </p>
                    {`<Super {...props}/>`}
                </div>
                
    return blockIf(WithVirtualHeader, shouldBlock, Message)
