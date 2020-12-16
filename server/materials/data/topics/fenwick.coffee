import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default fenwick = () ->
    return {
        topic: topic("Дерево Фенвика и многомерные деревья", "Задачи на дерево Фенвика", [
            label("<p>См. <a href=\"https://e-maxx.ru/algo/fenwick_tree\">теорию на e-maxx</a>.</p>"),
            label("В контесте ниже задачи можно решить и деревом отрезков (и часть из них уже была в соответствующем контесте), но решите теперь их деревом Фенвика."),
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