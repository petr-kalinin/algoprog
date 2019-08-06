React = require('react')
import Cookies from 'universal-cookie'
import withTheme from '../lib/withTheme'

ThemeCss = (props) ->
    cookies =  new Cookies
    cookies.set('Theme', props.theme)
    cookie = cookies.get('Theme')
    return if props.theme == "light"
               <link rel="stylesheet" href="/bootstrap.min.css" />
           else 
                <div>
                   <link rel="stylesheet" href="/bootstrapdark.min.css" />
                   <link rel="stylesheet" href="/additional_dark.css" />
                   <link rel="stylesheet" href="/darklight.css" />
                </div>

export default withTheme(ThemeCss)