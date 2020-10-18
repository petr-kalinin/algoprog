import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default sqrt_decomposition = () ->
    return {
        topic: topic("Sqrt-декомпозиция, она же корневая эвристика", "Задачи на sqrt-декомпозицию", [
            label("""<p>
                <a href=\"https://e-maxx.ru/algo/sqrt_decomposition\">Теория на e-maxx</a><br>
                <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Статистики_на_отрезках._Корневая_эвристика\">Теория в конспектах ИТМО</a><br>
                <a href=\"https://habrahabr.ru/post/138946/\">Статья на хабре</a><br/>
                <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Алгоритм_Мо\">Еще полезный прием</a>
                </p>"""),
            problem(934),
            problem(1361),
        ], "sqrt_decompositiom"),
        advancedProblems: [
            problem(113099),
            problem({testSystem: "codeforces", contest: "617", problem: "E"}),
            problem({testSystem: "codeforces", contest: "342", problem: "E"}),
        ]
    }