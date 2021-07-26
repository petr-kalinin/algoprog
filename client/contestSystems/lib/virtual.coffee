React = require('react')

import Button from 'react-bootstrap/lib/Button'

import globalStyles from '../../components/global.css'
import callApi from '../../lib/callApi'

startContest = (contestId, reload) ->
    () ->
        await callApi "startContest/#{contestId}", {}
        reload()

Header = (props) ->
    <div>
        {props.contestResult.virtualBlocked && 
            <div>
                <p>Этот контест виртуальный: нажмите кнопку, чтобы стартовать контест.</p>
                <Button type="submit" bsStyle="primary" onClick={startContest(props.contest._id, props.handleReload)}>
                    Начать виртуальный контест!
                </Button>
            </div>
        }
    </div>

PassedText = (props) ->
    if props.header
        return "Прошло"
    if not props.contestResult.startTime
        return ""
    passed = new Date() - new Date(props.contestResult.startTime)
    "#{Math.floor(passed / 60 / 1000)} мин."

UserAddInfoImpl = (props) ->
    <td className={globalStyles.mainTable_td}><PassedText {props...}/></td>

export default virtual = (cls) ->
    return class WithVirtualHeader extends cls
        Contest: () ->
            Super = super()
            (props) ->
                <div>
                    <Header {props...}/>
                    <Super {props...}/>
                </div>

        UserAddInfo: () ->
            Super = super()
            (props) ->
                [<Super {props...}/>,
                <UserAddInfoImpl {props...} />]
