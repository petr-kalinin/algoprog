import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default gcd = () ->
    return {
        topic: topic(
            ruen("НОД, алгоритм Евклида", "GCD, Euclidean algorithm"),
            ruen("Задачи на НОД", "Problems on GCD"),
        [label(ruen(
             "<a href=\"https://sis.khashaev.ru/2013/august/c-prime/2MBSsJ0TEMg/\">Видеозаписи лекций ЛКШ параллели C' про НОД и алгоритм Евклида</a>",
             "<a href=\"https://cp-algorithms.com/algebra/euclid-algorithm.html#time-complexity\">Cp-algorithms theory</a>,<br/>
             <a href=\"https://en.wikipedia.org/wiki/Euclidean_algorithm#Description\">Wikipedia theory</a>,<br/>
             <a href=\"https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm\">Khan academy theory</a>")),
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