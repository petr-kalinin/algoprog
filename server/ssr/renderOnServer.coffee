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
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"/>
            <link rel="stylesheet" href="/bundle.css"/>
            <script>
                window.__INITIAL_STATE__ = ' + JSON.stringify(data) + ';
            </script>
            <script type="text/x-mathjax-config">
                MathJax.Hub.Config({
                    extensions: ["tex2jax.js"],
                    jax: ["input/TeX", "output/HTML-CSS"],
                    tex2jax: {
                        inlineMath: [ ["$","$"] ],
                        displayMath: [ ["$$","$$"] ],
                        processEscapes: true
                    },
                    "HTML-CSS": { availableFonts: ["TeX"] }
                });
            </script>
            <script type="text/javascript" src="https://cdn.rawgit.com/davidjbradshaw/iframe-resizer/master/js/iframeResizer.contentWindow.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js?config=TeX-MML-AM_CHTML"></script>
        </head>
        <body>
            <div id="main" style="min-width: 100%; min-height: 100%">' + html + '</div>
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
    context = {}
    # We have already identified the element,
    # but we need StaticRouter for Link to work
    html = renderToString(
        <StaticRouter context={context}>
            {element}
        </StaticRouter>
    )

    res.set('Content-Type', 'text/html').status(200).end(renderFullPage(html, data))
