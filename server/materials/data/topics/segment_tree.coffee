import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default segment_tree = () ->
    return {
        topic: topic(
            ruen("Дерево отрезков", "Segment tree"),
            ruen("Задачи на дерево отрезков", "Problems on segment tree"),
        [label(ruen(
             "<p><a href=\"https://e-maxx.ru/algo/segment_tree\">Теория на e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Дерево_отрезков._Построение\">Теория на сайте ИТМО</a><br>\n<a href=\"https://habrahabr.ru/post/115026/\">Статья на хабре</a></p>",
             "<p><a href=\"https://e-maxx.ru/algo/segment_tree\">Theory on e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=\u0414\u0435\u0440\u0435\u0432\u043e_\u043e\u0442\u0440\u0435\u0437\u043a\u043e\u0432._\u041f\u043e\u0441\u0442\u0440\u043e\u0435\u043d\u0438\u0435\">Theory on the ITMO website</a><br>\n<a href=\"https://habrahabr.ru/post/115026/\">Article on habr</a></p>")),
            problem(752),
            problem(753),
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
