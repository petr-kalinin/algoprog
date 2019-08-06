React = require('react')
import withTheme from '../lib/withTheme'
import { CometSpinLoader } from 'react-css-loaders';

Loader = (props) ->
    return if props.theme == "light"
        <div>
            <CometSpinLoader {...props}/>
        </div>
    else 
        <div>
            <CometSpinLoader {...props} color={'#F8F6D9'}/>
        </div>

export default withTheme(Loader)