React = require('react')
import Alert from 'react-bootstrap/lib/Alert'
import { Link } from 'react-router-dom'

import TestSystem from './TestSystem'

export default class Codeforces extends TestSystem
    constructor: () ->
        super()

    id: () ->
        return "codeforces"

    problemLink: (material) ->
        if material.testSystemData.contest.startsWith("gym")
            href = "https://codeforces.com/#{material.testSystemData.contest}/problem/#{material.testSystemData.problem}"
        else
            href = "https://codeforces.com/problemset/problem/#{material.testSystemData.contest}/#{material.testSystemData.problem}"
        <p><a href={href}>Задача на Codeforces (контест {material.testSystemData.contest}, задача {material.testSystemData.problem}, © Codeforces.com)</a></p>

    submitListLink: (submit) ->
        if not submit.testSystemData.username
            return null
        href = "https://codeforces.com/submissions/#{submit.testSystemData.username}/contest/#{submit.testSystemData.contest}"
        <p><a href={href}>Попытки в контесте на codeforces</a></p>

    blockSubmission: (material, me, myUser) ->
        if me?.codeforcesUsername || myUser?.memberHasCf
            return null 
        return <Alert bsStyle="danger">
                    Это задача с <a href="https://codeforces.com">Codeforces</a>. Чтобы сдавать ее, зарегистрируйтесь на Codeforces и укажите данные аккаунта (логин и пароль) в <Link to="/user/#{me.informaticsId}">своем профиле</Link>.
            </Alert>
