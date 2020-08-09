React = require('react')
moment = require('moment')

import {Link} from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'

FindMistake = (props) ->
    <div>A</div>

options = {
    urls: (props) ->
        return
            comments: "findMistake/#{props.myUser._id}"
    timeout: 20000
}

AllCommentListConnected = ConnectedComponent(AllCommentList, options)

class AllCommentsWithPaginator extends React.Component
    constructor: (props) ->
        super(props);
        @state =
            activePage: 1
        @handlePageChange = @handlePageChange.bind this
    
    handlePageChange: (pageNumber) ->
        window.scrollTo(0, 0)
        @setState
            activePage: pageNumber
    
    render: () ->
        <div>
            <h1>Все комментарии</h1>
            <AllCommentListConnected page={@state.activePage - 1} />
            <Pagination
                activePage={@state.activePage}
                itemsCountPerPage={@props.data.commentsPerPage}
                totalItemsCount={@props.data.pagesCount * @props.data.commentsPerPage}
                pageRangeDisplayed={5}
                onChange={@handlePageChange}
            />
        </div>

pageOptions = {
    urls: (props) ->
        return
            data: "commentPages"
    timeout: 20000
}

export default ConnectedComponent(AllCommentsWithPaginator, pageOptions)
