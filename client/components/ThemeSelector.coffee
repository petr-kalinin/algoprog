React = require('react')
import { connect } from 'react-redux'

ThemeSelector = (props) ->
    return if props.theme == "light"
               <link rel="stylesheet" href="/bootstrap.min.css" />
           else 
                <div>
                   <link rel="stylesheet" href="/bootstrapdark.min.css" />
                   <link rel="stylesheet" href="/additional_dark.css" />
                   <link rel="stylesheet" href="/darklight.css" />
                </div>

mapStateToProps = (state) ->
    return
        theme: state.theme

export default Theme = connect(mapStateToProps)(ThemeSelector)