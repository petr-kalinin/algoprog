React = require('react')
moment = require('moment')

import ConnectedComponent from '../lib/ConnectedComponent'
import Panel from 'react-bootstrap/lib/Panel'
import PanelGroup from 'react-bootstrap/lib/PanelGroup'

class BlogPosts extends React.Component
    render:  () ->
        if not @props.posts.length
            return null
        <div>
            <h4>Последние записи в <a href="http://blog.algoprog.ru" target="_blank">блоге</a></h4>
            <PanelGroup>
                {
                @props.posts.map((post) =>
                    header = <a href={post.link} target="_blank">{moment(post.date).format('DD.MM.YYYY') + ": " + post.title}</a>
                    <Panel key={post._id} header={header}>
                    </Panel>
                )
                }
            </PanelGroup>
        </div>

options = {
    urls: (props) ->
        return
            posts: "lastBlogPosts"

    timeout: 5 * 60 * 1000
}

export default ConnectedComponent(BlogPosts, options)
