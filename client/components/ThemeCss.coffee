React = require('react')
import Cookies from 'universal-cookie'
import withTheme from '../lib/withTheme'

ThemeCss = (props) ->
    cookies =  new Cookies
    cookies.set('theme', props.theme)
    return if props.theme == "dark"
                <div>
                   <link rel="stylesheet" href="/bootstrapdark.min.css" />
                   <link rel="stylesheet" href="/additional_dark.css" />
                   <link rel="stylesheet" href="/darklight.css" />
                </div>
           else 
                <link rel="stylesheet" href="/bootstrap.min.css" />

export default withTheme(ThemeCss)