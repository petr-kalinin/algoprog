import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default primes = () ->
    return {
        topic: topic(
            ruen("Простые числа и разложение на множители", "Prime numbers and factorization"),
            ruen("Задачи на множители", "Problems on multipliers"),
        [label(ruen(
             "См. <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Арифметические алгоритмы»",
             "See video <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">recordings of lectures of Parallel C'</a> LCS, section \"Arithmetic algorithms\"")),
            problem(310),
            problem(623),
            problem(973),
        ], "primes"),
        advancedProblems: [
            problem(152),
            problem(584),
            problem(1009),
            problem(1037),
            problem(422),
        ]
    }