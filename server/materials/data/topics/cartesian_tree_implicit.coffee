import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default cartesian_tree_implicit  = () ->
    return {
        topic: topic("Декартово дерево по неявному ключу", "Задачи на декартово дерево по неявному ключу", [
            label("<p><a href=\"https://e-maxx.ru/algo/treap#7\">Теория на e-maxx</a><br>\n<a href=\"https://habrahabr.ru/post/102364/\">теория на хабре</a><br>\nДумаю, еще много чего легко ищется в интернете</p>"),
            problem(2791),
            problem(111881),
        ], "implicit_cartesian_tree"),
        advancedProblems: [
            problem(571),
        ]
    }