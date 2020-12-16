import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default primes = () ->
    return {
        topic: topic("Простые числа и разложение на множители", "Задачи на множители", [
            label("См. <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Арифметические алгоритмы»"),
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