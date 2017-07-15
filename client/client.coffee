React = require('react')
import { BrowserRouter, Route, Link} from 'react-router-dom'

ReactDOM = require('react-dom')

import Routes from './routes.coffee'

ReactDOM.render(
    <BrowserRouter>
        {Routes}
    </BrowserRouter>,
    document.getElementById('main')
)
