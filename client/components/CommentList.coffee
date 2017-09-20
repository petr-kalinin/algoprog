React = require('react')
moment = require('moment')

import Panel from 'react-bootstrap/lib/Panel'
import {Link} from 'react-router-dom'

import ConnectedComponent from '../pages/ConnectedComponent'

class CommentList extends React.Component
    constructor: (props) ->
        super(props)

    @url: (props) ->
        if props?.myUser?._id
            "lastComments/#{props.myUser._id}"

    @timeout: () ->
        20 * 1000

    render:  () ->
        if not @props.myUser?._id
            return null
        <div>
            <h4>Последние комментарии</h4>
            {
            if @props.data?.length
                @props.data.map((comment) =>
                    cl = undefined
                    switch comment.outcome
                        when "AC"
                            cl = "success"
                        when "IG"
                            cl = "info"
                    <Panel collapsible key={comment._id} header={comment.problemName} key={comment._id} bsStyle={cl}>
                        <pre>{comment.text}</pre>
                        <Link to="/material/#{comment.problemId}">Переход к задаче</Link>
                    </Panel>
                )
            }
        </div>

export default ConnectedComponent(CommentList)
