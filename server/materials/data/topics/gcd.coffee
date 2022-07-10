import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default gcd = () ->
    return {
        topic: topic(
            ruen("НОД, алгоритм Евклида", "NODE, Euclid's algorithm"),
            ruen("Задачи на НОД", "Problems on NODE"),
        [label("<a href=\"https://sis.khashaev.ru/2013/august/c-prime/2MBSsJ0TEMg/\">Видеозаписи лекций ЛКШ параллели C' про НОД и алгоритм Евклида</a>"),
            problem(199),
            problem(27),
            problem(1838),
        ], "gcd"),
        advancedProblems: [
            problem(1465),
            problem(668),
            problem(1422),
            problem(1346),
            problem(404),
            problem(1441),
        ]
    }