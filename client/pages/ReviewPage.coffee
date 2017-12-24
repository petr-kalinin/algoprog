React = require('react')

import Review from '../components/Review'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from '../lib/ConnectedComponent'

class ReviewPage extends React.Component
    constructor: (props) ->
        super(props)

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Ревью посылок", _id: "review"},
            showNews: "hide",
            showTree: "hide"
        }
        `<Sceleton {...sceletonProps}><Review {...this.props}/></Sceleton>`

options =
    urls: () ->
        "data": "dashboard"

export default ConnectedComponent(ReviewPage, options)
