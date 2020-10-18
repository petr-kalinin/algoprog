import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default floats =  () ->
    return {
        topic: topic("Вещественные числа", "Задачи на вещественные числа", [
            label("<a href=\"https://notes.algoprog.ru/python_basics/5_float.html\">Теория по вещественным числам (в основном про питон, но читать всем независимо от языка!)</a>"),
            problem(74),
            problem(3612),
            problem(596),
            problem(597),
            problem(595),
            problem(120),
        ], "floats"),
        advancedTopics: [
            label("Две последние задачи в \"Продвинутых задачах на вещественные числа\" повторяют задачи из просто \"Задач на вещественные числа\" с уровня 1Б. Так задумано для тех, кто не решал уровень 1Б; если вы решали контест на вещественные числа на уровне 1Б, то вам пересдавать эти задачи не надо."),
            contest("Продвинутые задачи на вещественные числа", [
                problem(3609),
                problem(3613),
                problem(3614),
                problem(3622),
                problem(74),
                problem(595),
            ])
        ]
    }