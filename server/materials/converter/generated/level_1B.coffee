import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_15976 = () ->
    return topic("Символы и строки", "1Б: Задачи на символы и строки", [
        label("<a href=\"http://notes.algoprog.ru/python_basics/4_strings.html\">Питон: теория по символам и строкам</a>"),
        problem(102),
        problem(103),
        problem(105),
        problem(106),
        problem(108),
    ])

topic_15973 = () ->
    return topic("Массивы", "1Б: Задачи на массивы", [
        label("<a href=\"http://notes.algoprog.ru/python_basics/3_arrays.html\">Питон: теория по массивам</a>"),
        problem(63),
        problem(64),
        problem(66),
        problem(69),
        problem(71),
        problem(72),
        problem(355),
        problem(357),
        problem(362),
    ])

topic_15978 = () ->
    return topic("Вещественные числа", "1Б: Задачи на вещественные числа", [
        label("<a href=\"http://notes.algoprog.ru/python_basics/5_float.html\">Теория по вещественным числам (в основном про питон, но читать всем независимо от языка!)</a>"),
        problem(74),
        problem(3612),
        problem(596),
        problem(597),
        problem(595),
        problem(120),
    ])

export default level_1B = () ->
    return level("1Б", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_15973(),
        topic_15976(),
        topic_15978(),
    ])