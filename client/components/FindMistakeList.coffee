React = require('react')
moment = require('moment')

import { ListGroup, ListGroupItem, Button, ButtonGroup } from 'react-bootstrap'
import Pagination from "react-js-pagination";
import {Link} from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'
import withMyUser from '../lib/withMyUser'

ORDER_PROBLEM = "problem"
ORDER_STATUS = "status"

getClass = (result) ->
    if not result
        return undefined    
    switch
        when result.solved > 0 then "success"
        when result.ok > 0 then "success"
        when result.ignored > 0 then "info"
        when result.attempts > 0 then "danger"
        else undefined

FindMistakeList = (props) ->
    <ListGroup>
        {props.findMistakes.map? (m) ->
            href = "/findMistake/" + m._id
            if not m.allowed
                href = undefined
            cl = getClass(m.result)
            <ListGroupItem key={m._id} onClick={if m.allowed then window?.goto?(href)} href={href} bsStyle={cl} disabled={!m.allowed}>
                {m.fullProblem.name}{" "} 
                ({m.fullProblem.level}, {m.language}){" "} 
                <small>#{m.hash}</small>
            </ListGroupItem>
        }
    </ListGroup>

options = 
    urls: (props) ->
        return
            findMistakes: if props.problem then "findMistakeProblemList/#{props.myUser?._id}/#{props.problem}/#{props.page}" else "findMistakeList/#{props.myUser?._id}/#{props.page}?order=#{props.order}"

FindMistakeListConnected = withMyUser(ConnectedComponent(FindMistakeList, options))

class FindMistakeListWithPaginator extends React.Component
    constructor: (props) ->
        super(props);
        @state =
            activePage: 1
            order: ORDER_PROBLEM
        @handlePageChange = @handlePageChange.bind this
        @sortBy = @sortBy.bind this
    
    handlePageChange: (pageNumber) ->
        window.scrollTo(0, 0)
        @setState
            order: pageNumber

    sortBy: (order) ->
        (e) =>
            @setState
                order: order
    
    render: () ->
        <div>
            <h1>Найди ошибку</h1>
            <p><Link to="/material/about_find_mistake">О поиске ошибок</Link></p>
            {@props.allowSort && 
                <p><ButtonGroup>
                    <Button onClick={@sortBy(ORDER_PROBLEM)} active={@state.order==ORDER_PROBLEM} bsSize="xsmall">Сортировать по задаче</Button>
                    <Button onClick={@sortBy(ORDER_STATUS)} active={@state.order==ORDER_STATUS} bsSize="xsmall">Сортировать по статусу</Button>
                </ButtonGroup></p>
            }
            <FindMistakeListConnected page={@state.activePage - 1} problem={@props.problem} order={@state.order}/>
            <Pagination
                activePage={@state.activePage}
                itemsCountPerPage={@props.data.perPage}
                totalItemsCount={@props.data.pagesCount * @props.data.perPage}
                pageRangeDisplayed={5}
                onChange={@handlePageChange}
            />
        </div>

pageOptions = {
    urls: (props) ->
        return
            data: if props.problem then "findMistakeProblemPages/#{props.myUser?._id}/#{props.problem}" else "findMistakePages/#{props.myUser?._id}"
}

export default withMyUser(ConnectedComponent(FindMistakeListWithPaginator, pageOptions))
