React = require('react')

import {BigAchieves} from './Achieves'
import UserName from './UserName'

import {LangRawAny} from '../lang/lang'

import ACHIEVES from '../lib/achieves'
import withLang from '../lib/withLang'

export default UsersWithAchieve = withLang (props) ->
    <div>
        <BigAchieves achieves={[props.achieve]}/>
        <h1>{LangRawAny(ACHIEVES[props.achieve].title, props.lang, props.achieve)}</h1>
        {props.users.map((user) ->
            <div key={user._id}><UserName user={user}/></div>
        )}
    </div>
