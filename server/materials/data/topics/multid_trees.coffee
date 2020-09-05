import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default multid_trees = () ->
    return {
        topic: topic("Многомерные деревья", "Задачи на многомерные деревья", [
            label("<p>См. теорию на e-maxx: <a href=\"https://e-maxx.ru/algo/segment_tree#25\">деревья отрезков</a>, <a href=\"https://e-maxx.ru/algo/fenwick_tree#4\">дерево Фенвика</a>.</p>"),
            problem(3013),
            problem(111778),
        ]),
        advancedProblems: [
            problem(113809),
        ]
    }