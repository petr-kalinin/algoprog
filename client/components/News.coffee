React = require('react')

import Panel from 'react-bootstrap/lib/Panel'
import PanelGroup from 'react-bootstrap/lib/PanelGroup'

import LANG from '../lang/lang'

import ConnectedComponent from '../lib/ConnectedComponent'
import withLang from '../lib/withLang'

News = (props) ->
    <div>
        <h4>{LANG("news", props.lang)}</h4>
        <PanelGroup id="news">
            {
            res = []
            a = (el) -> res.push(el)
            for m, i in props.news?.materials || []
                a <Panel key={i}>
                    <Panel.Heading>
                        <Panel.Title toggle>{m.title}</Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body><div dangerouslySetInnerHTML={{__html: m.content}}/></Panel.Body>
                    </Panel.Collapse>
                </Panel>
            res
            }
        </PanelGroup>
    </div>

options =
    urls: (props) ->
        LANG("news_url", props.lang)

export default withLang(ConnectedComponent(News, options))
