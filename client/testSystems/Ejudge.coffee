React = require('react')

import TestSystem from './TestSystem'

export default class Ejudge extends TestSystem
    constructor: (@server, @baseContest) ->
        super()

    id: () ->
        return "ejudge"

    problemLink: (material) ->
        href = "#{@server}/cgi-bin/new-client?contest_id=#{material.testSystemData.contest}"
        <p><a href={href}>Контест в ejudge</a></p>

    submitListLink: (submit) ->
        href = "#{@server}/cgi-bin/new-client?contest_id=#{submit.testSystemData.contest}"
        <p><a href={href}>Контест в ejudge</a></p>
