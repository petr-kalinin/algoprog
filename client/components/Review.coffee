React = require('react')

import Button from 'react-bootstrap/lib/Button'

import ReviewResult from './ReviewResult'

export default class Review extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            results: (r for r in props.data.ok when r?.activated)
        @gotoNext = @gotoNext.bind this

    gotoNext: () ->
        @setState
            results: @state.results[...-1]

    componentDidUpdate: (prevProps) ->
        if @props.data?.ok[0]?._id != prevProps.data?.ok[0]?._id
            @setState
                results: (r for r in @props.data.ok when r?.activated)

    render: () ->
        <div>
            ={@state.results.length} <Button onClick={@props.handleReload}>Обновить</Button>
            {
            if @state.results.length == 0
                <div>Ревьювить больше нечего, обновите страницу</div>
            else
                <div>
                    <ReviewResult result={@state.results[@state.results.length-1]} handleDone={@gotoNext}/>
                    {@state.results.length > 1 &&    # prefetch next submit
                        <div style={{display: "none"}}>
                            <ReviewResult result={@state.results[@state.results.length-2]} handleDone={@gotoNext}/>
                        </div>}
                </div>
            }
        </div>
