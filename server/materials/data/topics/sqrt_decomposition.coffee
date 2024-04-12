import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default sqrt_decomposition = () ->
    return {
        topic: topic(
            ruen("Sqrt-декомпозиция, она же корневая эвристика", "Sqrt decomposition, aka root heuristics"),
            ruen("Задачи на sqrt-декомпозицию", "Problems on sqrt decomposition"),
        [label(ruen("""<p>
                <a href=\"https://e-maxx.ru/algo/sqrt_decomposition\">Теория на e-maxx</a><br>
                <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Статистики_на_отрезках._Корневая_эвристика\">Теория в конспектах ИТМО</a><br>
                <a href=\"https://habrahabr.ru/post/138946/\">Статья на хабре</a><br/>
                <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Алгоритм_Мо\">Алгоритм Мо (немного другой прием для других задач, но базовая идея та же)</a>
                </p>""",
                """<p>
                <a href=\"https://e-maxx.ru/algo/sqrt_decomposition\">Theory on e-maxx</a><br>
                <a href=\"http://neerc.ifmo.ru/wiki/index.php?title=Statisticsreferences._corn_heuristics\">Theory in ITMO notes</a><br>
                <a href=\"https://habrahabr.ru/post/138946/\">Article on habr</a><br/>
                <a href=\"http://neerc.ifmo.ru/wiki/index.php?title=ALGORITHM_MO\">Mo algorithm (a bit different idea, but the basis is same)</a>
                </p>
                """)),
            problem(1663),
            problem(113784),
            problem(113785),
            problem(114218),
            problem(1361),
            problem({testSystem: "codeforces", contest: "220", problem: "B"}),
        ], "sqrt_decomposition"),
        advancedProblems: [
            problem(934),
            problem({testSystem: "codeforces", contest: "963", problem: "D"}),
            problem(113099),
            problem({testSystem: "codeforces", contest: "617", problem: "E"}),
            problem({testSystem: "codeforces", contest: "342", problem: "E"}),
        ]
    }