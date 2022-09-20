import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default floats =  () ->
    return {
        topic: topic(
            ruen("Вещественные числа", "Real numbers"),
            ruen("Задачи на вещественные числа", "Problems on real numbers"),
        [label(ruen(
             "<a href=\"https://notes.algoprog.ru/python_basics/5_float.html\">Теория по вещественным числам (в основном про питон, но читать всем независимо от языка!)</a>",
             "<a href=\"https://notes.algoprog.ru/en/python_basics/5_float.html\">Theory on real numbers (mostly about python, but must-read regardless of language!)</a>")),
            problem({testSystem: "ejudge", contest: "3008", problem: "1", id: "74"}),
            problem({testSystem: "ejudge", contest: "3008", problem: "2", id: "3612"}),
            problem({testSystem: "ejudge", contest: "3008", problem: "3", id: "596"}),
            problem({testSystem: "ejudge", contest: "3008", problem: "4", id: "597"}),
            problem({testSystem: "ejudge", contest: "3008", problem: "5", id: "595"}),
            problem({testSystem: "ejudge", contest: "3008", problem: "6", id: "120"}),
        ], "floats"),
        advancedTopics: [
            label(ruen(
                "Две последние задачи в \"Продвинутых задачах на вещественные числа\" повторяют задачи из просто \"Задач на вещественные числа\" с уровня 1Б. Так задумано для тех, кто не решал уровень 1Б; если вы решали контест на вещественные числа на уровне 1Б, то вам пересдавать эти задачи не надо.",
                "The last two problems in \"Advanced problems on real numbers\" repeat the problems from just \"Problems on real number\" from level 1B. This is intended for those who have not solved level 1B; if you have solved a contest on real numbers at level 1B, then you do not need to solve these problems again.")),
            contest(ruen(
                "Продвинутые задачи на вещественные числа",
                "Advanced problems on real numbers"), [
                problem(3609),
                problem(3613),
                problem(3614),
                problem(3622),
                problem(74),
                problem(595),
            ])
        ]
    }