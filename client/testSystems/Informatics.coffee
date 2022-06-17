React = require('react')

import {LangRaw} from '../lang/lang'

import TestSystem from './TestSystem'

export default class Informatics extends TestSystem
    BASE_URL = "https://informatics.msk.ru"

    _informaticsProblemId: (problemId) ->
        problemId.substring(1)

    id: () ->
        return "informatics"

    problemLink: (material, lang) ->
        id = @_informaticsProblemId(material._id)
        href = "#{BASE_URL}/mod/statements/view.php?chapterid=#{id}"
        <p><a href={href}>{LangRaw("informatics_problem_link", lang)}</a></p>

    submitListLink: (submit, lang) ->
        id = @_informaticsProblemId(submit.problem)
        <a href={"#{BASE_URL}/mod/statements/view.php?chapterid=#{id}&submit&user_id=#{submit.user}"} target="_blank">{LangRaw("informatics_submits_link", lang)}</a>
