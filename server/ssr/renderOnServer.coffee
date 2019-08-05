React = require('react')

import { StaticRouter } from 'react-router'
import { renderToString } from 'react-dom/server';
import { matchPath, Switch, Route } from 'react-router-dom'

import { Provider } from 'react-redux'

import { Helmet } from "react-helmet"

import Routes from '../../client/routes'
import DefaultHelmet from '../../client/components/DefaultHelmet'
import ConnectedNotifications from '../../client/components/ConnectedNotifications'

import createStore from '../../client/redux/store'
import awaitAll from '../../client/lib/awaitAll'

import User from '../models/user'
import logger from '../log'

renderFullPage = (html, data, helmet) ->
    return '
        <html>
        <head>
            <meta charset="UTF-8" />
            <meta name="yandex-verification" content="4f0059cd93dfb218" />
            ' + helmet.title + '
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"/>
            <link rel="stylesheet" href="/bundle.css"/>
            <link rel="stylesheet" href="/react-diff-view.css"/>
            <link rel="stylesheet" href="/informatics.css"/>
            <link rel="stylesheet" href="/highlight.css"/>
            <link rel="stylesheet" href="/main.css"/>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <script>
                window.__PRELOADED_STATE__ = ' + JSON.stringify(data) + ';
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
            <script src="/highlight.pack.js"></script>
        </head>
        <body>
            <div id="main" style="min-width: 100%; min-height: 100%">' + html + '</div>
            <script src="/bundle.js" type="text/javascript"></script>
            <!-- Yandex.Metrika counter -->
            <script type="text/javascript" >
                (function (d, w, c) {
                    (w[c] = w[c] || []).push(function() {
                        try {
                            w.yaCounter45895896 = new Ya.Metrika({
                                id:45895896,
                                clickmap:true,
                                trackLinks:true,
                                accurateTrackBounce:true,
                                webvisor:true
                            });
                        } catch(e) { }
                    });

                    var n = d.getElementsByTagName("script")[0],
                        s = d.createElement("script"),
                        f = function () { n.parentNode.insertBefore(s, n); };
                    s.type = "text/javascript";
                    s.async = true;
                    s.src = "https://mc.yandex.ru/metrika/watch.js";

                    if (w.opera == "[object Opera]") {
                        d.addEventListener("DOMContentLoaded", f, false);
                    } else { f(); }
                })(document, window, "yandex_metrika_callbacks");
            </script>
            <noscript><div><img src="https://mc.yandex.ru/watch/45895896" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
            <!-- /Yandex.Metrika counter -->
        </body>
        </html>'

export default renderOnServer = (req, res, next) =>
    try
        initialState = 
            data: [
                {data: req.user
                success: true
                updateTime: new Date()
                url: "me"},
                {data: await User.findById(req.user?.userKey())
                success: true
                updateTime: new Date()
                url: "myUser"},
            ],
            clientCookie: req.headers.cookie
        store = createStore(initialState)

        component = undefined
        foundMatch = undefined
        Routes.some((route) ->
            match = matchPath(req.path, route)
            if (match)
                foundMatch = match
                component = route.component
            return match
        )
        element = React.createElement(component, {match: foundMatch})
        context = {}

        # We have already identified the element,
        # but we need StaticRouter for Link to work
        wrappedElement = <Provider store={store}>
                <div>
                    <DefaultHelmet/>
                    <StaticRouter context={context}>
                        {element}
                    </StaticRouter>
                </div>
            </Provider>

        html = renderToString(wrappedElement)
        await awaitAll(store.getState().dataPromises)

        wrappedElement = <Provider store={store}>
                <div>
                    <DefaultHelmet/>
                    <StaticRouter context={context}>
                        <div>
                            {element}
                            <ConnectedNotifications/>
                        </div>
                    </StaticRouter>
                </div>
            </Provider>
        html = renderToString(wrappedElement)

    catch error
        logger.error(error)
        res.status(500).send('Error 500')
        return
    finally
        helmet = Helmet.renderStatic();

    state = store.getState()
    delete state.dataPromises

    res.set('Content-Type', 'text/html').status(200).end(renderFullPage(html, state, helmet))
