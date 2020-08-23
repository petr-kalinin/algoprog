React = require('react')

import TestSystem from './TestSystem'

export default class Informatics extends TestSystem
    BASE_URL = "https://informatics.msk.ru"

    _informaticsProblemId: (problemId) ->
        problemId.substring(1)

    id: () ->
        return "informatics"

    problemLink: (material) ->
        id = @_informaticsProblemId(material._id)
        href = "#{BASE_URL}/mod/statements/view.php?chapterid=#{id}"
        <p><a href={href}>Задача на informatics</a></p>

    submitListLink: (submit) ->
        id = @_informaticsProblemId(submit.problem)
        <a href={"#{BASE_URL}/mod/statements/view.php?chapterid=#{id}&submit&user_id=#{submit.user}"} target="_blank">Попытки на информатикс</a>
