import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default floats =  () ->
    return topic("Вещественные числа", "1Б: Задачи на вещественные числа", [
        label("<a href=\"https://notes.algoprog.ru/python_basics/5_float.html\">Теория по вещественным числам (в основном про питон, но читать всем независимо от языка!)</a>"),
        problem(74),
        problem(3612),
        problem(596),
        problem(597),
        problem(595),
        problem(120),
    ])