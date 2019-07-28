React = require('react')

import Panel from 'react-bootstrap/lib/Panel'
import PanelGroup from 'react-bootstrap/lib/PanelGroup'

import ConnectedComponent from '../lib/ConnectedComponent'

News = (props) ->
    <div>
        <h4>Новости</h4>
        <PanelGroup id="news">
            {
            res = []
            a = (el) -> res.push(el)
            for m, i in props.news?.materials || []
                a <Panel key={i}>
                    <Panel.Heading>
                        <Panel.Title toggle>{m.header}</Panel.Title>
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
        news: "material/news"

export default ConnectedComponent(News, options)
