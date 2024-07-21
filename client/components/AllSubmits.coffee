React = require('react')
moment = require('moment')

import {bootstrapUtils} from 'react-bootstrap/lib/utils'

FontAwesome = require('react-fontawesome')

import Pagination from "react-js-pagination";

import {Link} from 'react-router-dom'
import { connect } from 'react-redux'
import Lang from '../lang/lang'
import {LangRaw} from '../lang/lang'

import ConnectedComponent from '../lib/ConnectedComponent'

import SubmitListTable from './SubmitListTable'

import globalStyles from './global.css'

class Submits extends React.Component
    render: () ->
        <div>
            <SubmitListTable submits={@props.data} showProblems={true} />
        </div>

SubmitsConnected = ConnectedComponent(Submits, {
    urls: (props) ->
        data: "lastSubmits/#{props._id}/#{props.page}?lang=#{LangRaw("material_suffix", props.lang)}"
})
 
class AllSubmits extends React.Component
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
            <h1>{LangRaw("all_submits", @props.lang)}</h1>
            <SubmitsConnected _id = {@props.userId} page={@state.activePage - 1} lang={@props.lang}/>
            <Pagination
                activePage={@state.activePage}
                itemsCountPerPage={@props.data.submitsPerPage}
                totalItemsCount={@props.data.pagesCount * @props.data.submitsPerPage}
                pageRangeDisplayed={5}
                onChange={@handlePageChange}
            />
        </div>

pageOptions = {
    urls: (props) ->
        return
            data: "lastSubmitsPages/#{props.userId}"
    timeout: 20000
}

export default ConnectedComponent(AllSubmits, pageOptions)
