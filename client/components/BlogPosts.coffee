React = require('react')
moment = require('moment')

import ConnectedComponent from '../lib/ConnectedComponent'
import Panel from 'react-bootstrap/lib/Panel'
import PanelGroup from 'react-bootstrap/lib/PanelGroup'

class BlogPosts extends React.Component
    render:  () ->
        return null
        if not @props.posts.length
            return null
        <div>
            <h4>Последние записи в блоге</h4>
            <PanelGroup id="blogPosts">
                {
                @props.posts.map((post) =>
                    header = <a href={post.link} target="_blank">{moment(post.date).format('DD.MM.YYYY') + ": " + post.title}</a>
                    <Panel key={post._id}>
                        <Panel.Heading>
                            <Panel.Title>{header}</Panel.Title>
                        </Panel.Heading>
                    </Panel>
                )
                }
            </PanelGroup>
            <a href="//blog.algoprog.ru" target="_blank">Все записи</a>
        </div>

options = {
    urls: (props) ->
        return
            posts: "lastBlogPosts"

    timeout: 5 * 60 * 1000
}

export default ConnectedComponent(BlogPosts, options)
