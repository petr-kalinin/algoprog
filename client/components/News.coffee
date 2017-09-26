React = require('react')

import Panel from 'react-bootstrap/lib/Panel'
import PanelGroup from 'react-bootstrap/lib/PanelGroup'

export default News = (props) ->
    <div>
        <h4>Новости</h4>
        {
        res = []
        a = (el) -> res.push(el)
        for m, i in props.news
            a <Panel collapsible header={m.header} key={i}><div dangerouslySetInnerHTML={{__html: m.content}}/></Panel>
        res
        }
    </div>
