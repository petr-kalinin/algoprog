React = require('react')
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import { Link } from 'react-router-dom'

import callApi from '../lib/callApi'
import ConnectedComponent from '../lib/ConnectedComponent'

import {SubmitListWithDiff} from './ReviewResult'
import Submit from './Submit'

SubmitComponent = (props) ->
    <Submit submit={props.currentSubmit} showHeader/>

PostSubmit = (props) ->
    <>
        <ButtonGroup>
            <Button onClick={props.setApprove(true)} bsStyle="success">Ок</Button>
            <Button onClick={props.setApprove(false)} bsStyle="danger">Не ок</Button>
        </ButtonGroup>
    </>

class ApproveFindMistake extends React.Component
    constructor: (props) ->
        super(props)
        @setApprove = @setApprove.bind this

    setApprove: (approve) ->
        () =>
            await callApi "setApproveFindMistake/#{@props.data.mistake._id}", { approve }
            @props.handleReload()

    render: () ->
        <>
            <div>Всего: {@props.data.count}</div>
            {
            if not @props.data.mistake
                <div>Тут ничего нет</div>
            else
                <SubmitListWithDiff submits={@props.data.submits} setApprove={@setApprove} SubmitComponent={SubmitComponent} PostSubmit={PostSubmit}/>
            }
        </>

options = {
    urls: (props) ->
        return
            data: "approveFindMistake"
}

export default ConnectedComponent(ApproveFindMistake, options)