React = require('react')

import TestSystem from './TestSystem'

export default class Ejudge extends TestSystem
    constructor: () ->
        super()

    id: () ->
        return "codeforces"

    problemLink: (material) ->
        href = "https://codeforces.com/problemset/problem/#{material.testSystemData.contest}/#{material.testSystemData.problem}"
        <p><a href={href}>Задача на Codeforces (контест {material.testSystemData.contest}, задача {material.testSystemData.problem}, © Codeforces.com)</a></p>

    submitListLink: (submit) ->
        if not submit.testSystemData.username
            return null
        href = "https://codeforces.com/submissions/#{submit.testSystemData.username}/contest/#{submit.testSystemData.contest}"
        <p><a href={href}>Попытки в контесте на codeforces</a></p>
