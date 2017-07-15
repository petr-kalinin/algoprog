import Routes from '../../client/routes'
React = require('react')
import { StaticRouter } from 'react-router'
import { renderToString } from 'react-dom/server';

renderFullPage = (html) ->
    return '
        <html>
        <head>
            <meta charset="UTF-8" />
            <title>Test</title>
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/latest/css/bootstrap.min.css"/>  
            <link rel="stylesheet" href="/bundle.css"/>  
        </head>
        <body>
            <div id="main">' + html + '</div>
            <script src="/bundle.js" type="text/javascript"></script>
        </body>
        </html>'

export default renderOnServer = (req, res, next) => 
    context = {}
    html = renderToString (
        <StaticRouter location={req.url} context={context}>
            {Routes}
        </StaticRouter>
    )

    res.set('Content-Type', 'text/html').status(200).end(renderFullPage(html))
