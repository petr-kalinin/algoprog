import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default fenwick = () ->
    return {
        topic: topic(
            ruen("Дерево Фенвика и многомерные деревья", "Fenwick tree and multidimensional trees"),
            ruen("Задачи на дерево Фенвика", "Problems on fenwick tree"),
        [label(ruen(
             "<p>См. <a href=\"https://e-maxx.ru/algo/fenwick_tree\">теорию на e-maxx</a>.</p>",
             "<p>See the <a href=\"https://e-maxx.ru/algo/fenwick_tree\">theory on e-maxx</a>.</p>")),
            label(ruen(
                "В контесте ниже задачи можно решить и деревом отрезков (и часть из них уже была в соответствующем контесте), но решите теперь их деревом Фенвика.",
                "In the contest below, the problems can also be solved with a tree of segments (and some of them have already been in the corresponding contest), but now solve them with a Fenwick tree.")),
            problem(3317),
            problem(3568),
            problem(3013),
            problem(111778),
        ], "fenwick"),
        advancedProblems: [
            problem(113556),
            problem(1049),
        ]
    }