React = require('react')
import { connect } from 'react-redux'
import { CometSpinLoader } from 'react-css-loaders';

Loader = (props) ->
    return if props.theme == "light"
        <div>
            <CometSpinLoader/>
        </div>
    else 
        <div>
            <CometSpinLoader color={'#F8F6D9'}/>
        </div>


mapStateToProps = (state) ->
    return
        theme: state.theme

export default Loader = connect(mapStateToProps)(Loader)