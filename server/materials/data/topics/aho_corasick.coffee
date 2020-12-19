import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default aho_corasick = () ->
    return {
        topic: topic("Алгоритм Ахо-Корасик", "Задачи на Ахо-Корасик", [
            label("<p>См. <a href=\"https://e-maxx.ru/algo/aho_corasick\">теорию на e-maxx</a>.</p>"),
            problem(111732),
        ], "aho"),
        advancedProblems: [
            problem(2881),
        ]
    }