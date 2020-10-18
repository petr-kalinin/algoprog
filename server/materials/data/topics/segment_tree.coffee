import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default segment_tree = () ->
    return {
        topic: topic("Дерево отрезков", "Задачи на дерево отрезков", [
            label("<p><a href=\"https://e-maxx.ru/algo/segment_tree\">Теория на e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Дерево_отрезков._Построение\">Теория на сайте ИТМО</a><br>\n<a href=\"https://habrahabr.ru/post/115026/\">Статия на хабре</a></p>"),
            problem(752),
            problem(753),
            problem(1364),
            problem(3312),
            problem(3321),
            problem(3335),
        ], "segment_tree"),
        advancedProblems: [
            problem(3320),
            problem(3568),
            problem(3318),
            problem(111744),
        ]
    }