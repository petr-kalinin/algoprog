React = require('react')

import Review from '../components/Review'
import Sceleton from '../components/Sceleton'
import ConnectedComponent from './ConnectedComponent'

class ReviewPage extends React.Component
    constructor: (props) ->
        super(props)

    @url: () ->
        "dashboard"

    render:  () ->
        sceletonProps = {
            @props...,
            location: {title: "Ревью посылок", _id: "review"},
            showNews: "hide",
            showTree: "hide"
        }
        `<Sceleton {...sceletonProps}><Review {...this.props}/></Sceleton>`


export default ConnectedComponent(ReviewPage)
