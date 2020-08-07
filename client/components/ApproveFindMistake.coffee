React = require('react')
import { Link } from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'

import {ReviewResult} from './ReviewResult'

ApproveFindMistake = (props) ->
    fakeResult = 
        _id: ""
    <ReviewResult submits={props.data.submits} user={{}} bestSubmits={[]} me={{}} result={fakeResult}/>

options = {
    urls: (props) ->
        return
            data: "approveFindMistake"
}

export default ConnectedComponent(ApproveFindMistake, options)