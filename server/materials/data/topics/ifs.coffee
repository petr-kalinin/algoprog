import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default ifs = () ->
    return topic("Условный оператор", "1А: Задачи на условный оператор", [
        label("<a href=\"https://notes.algoprog.ru/python_basics/1_if.html\">Питон: теория по условному оператору</a>"),
        label("<a href=\"https://blog.algoprog.ru/do-not-check-limits/\">Не надо проверять, выполняются ли ограничения из условия</a>"),
        problem(292),
        problem(293),
        problem(2959),
        problem(294),
        problem(253),
    ])
