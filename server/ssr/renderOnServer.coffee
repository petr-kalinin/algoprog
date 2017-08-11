import Routes from '../../client/routes'
React = require('react')
import { StaticRouter } from 'react-router'
import { renderToString } from 'react-dom/server';
import { matchPath, Switch, Route } from 'react-router-dom'

renderFullPage = (html, data) ->
    return '
        <html>
        <head>
            <meta charset="UTF-8" />
            <title>Сводные таблицы</title>
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/latest/css/bootstrap.min.css"/>  
            <link rel="stylesheet" href="/bundle.css"/>  
            <script>
                window.__INITIAL_STATE__ = ' + JSON.stringify(data) + ';
            </script>
        </head>
        <body>
            <div id="main">' + html + '</div>
            <script src="/bundle.js" type="text/javascript"></script>
        </body>
        </html>'

export default renderOnServer = (req, res, next) => 
    component = undefined
    foundMatch = undefined
    data = undefined
    
    Routes.some((route) ->
        match = matchPath(req.url, route)
        if (match)
            foundMatch = match
            component = route.component
            if component.loadData
                data = component.loadData(match)
        return match
    )
    data = await data
    element = React.createElement(component, {match: foundMatch, data: data})
    html = renderToString(element)

    res.set('Content-Type', 'text/html').status(200).end(renderFullPage(html, data))

