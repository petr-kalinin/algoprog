React = require('react')
import { Link } from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'

import {SubmitListWithDiff} from './ReviewResult'
import Submit from './Submit'

SubmitComponent = (props) ->
    <Submit submit={props.currentSubmit} showHeader/>

ApproveFindMistake = (props) ->
    console.log props.data.submits
    <SubmitListWithDiff submits={props.data.submits} SubmitComponent={SubmitComponent}/>

options = {
    urls: (props) ->
        return
            data: "approveFindMistake"
}

export default ConnectedComponent(ApproveFindMistake, options)