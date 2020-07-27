React = require('react')

import {BigAchieves} from './Achieves'
import UserName from './UserName'

import ACHIEVES from '../lib/achieves'

export default UsersWithAchieve = (props) ->
    <div>
        <BigAchieves achieves={[props.achieve]}/>
        <h1>{ACHIEVES[props.achieve].title}</h1>
        {props.users.map((user) ->
            <div key={user._id}><UserName user={user}/></div>
        )}
    </div>
