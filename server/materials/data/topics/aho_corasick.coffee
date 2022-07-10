import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default aho_corasick = () ->
    return {
        topic: topic(
            ruen("Алгоритм Ахо-Корасик", "The Aho-Korasik algorithm"),
            ruen("Задачи на Ахо-Корасик", "Problems on Aho-Korasik"),
        [label(ruen(
             "<p>См. <a href=\"https://e-maxx.ru/algo/aho_corasick\">теорию на e-maxx</a>.</p>",
             "<p>See the <a href=\"https://e-maxx.ru/algo/aho_corasick\">theory on e-maxx</a>.</p>")),
            problem(111732),
        ], "aho"),
        advancedProblems: [
            problem(2881),
        ]
    }