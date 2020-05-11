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
        href = "#{BASE_URL}/moodle/mod/statements/view3.php?chapterid=#{id}"
        <p><a href={href}>Задача на informatics</a></p>

    submitListLink: (problem, user) ->
        id = @_informaticsProblemId(problem._id)
        "#{BASE_URL}/moodle/mod/statements/view3.php?" + "chapterid=#{id}&submit&user_id=#{user._id}"
