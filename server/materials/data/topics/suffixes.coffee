import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default suffixes = () ->
    return {
        topic: topic("Суффиксные структуры данных", "Задачи на суффиксные структуры", [
            label("<p>См. теорию на e-maxx: <br>\n<a href=\"https://e-maxx.ru/algo/suffix_array\">суффиксный массив</a>, <br>\n<a href=\"https://e-maxx.ru/algo/suffix_automata\">суффиксный автомат</a>, <br>\n<a href=\"https://e-maxx.ru/algo/ukkonen\">суффиксное дерево</a>.</p>"),
            problem(111789),
        ], "suffixes"),
        advancedProblems: [
            problem(113932),
        ]
    }