import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default cartesian_tree = () ->
    return {
        topic: topic(
            ruen("Декартово дерево", "Cartesian tree (treap)"),
            ruen("Задачи на декартовы деревья", "Problems on cartesian trees"),
        [label(ruen(
             "<p>Для начала почитайте про <a href=\"https://ru.wikipedia.org/wiki/Двоичное_дерево_поиска\">двоичные деревья поиска</a>, ну или <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Дерево_поиска%2C_наивная_реализация\">еще здесь</a>. Вам не обязательно (пока) уметь их писать, но просто поймите, что это такое и с чем его едят.</p>\n<p><a href=\"https://e-maxx.ru/algo/treap\">Теория на e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Декартово_дерево\">Теория на сайте ИТМО</a><br>\nМожете еще погуглить\n</p>",
             "<p>To begin with, read about <a href=\"https://ru.wikipedia.org/wiki/\u0414\u0432\u043e\u0438\u0447\u043d\u043e\u0435_\u0434\u0435\u0440\u0435\u0432\u043e_\u043f\u043e\u0438\u0441\u043a\u0430\">binary search trees</a>, well, or <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=\u0414\u0435\u0440\u0435\u0432\u043e_\u043f\u043e\u0438\u0441\u043a\u0430%2C_\u043d\u0430\u0438\u0432\u043d\u0430\u044f_\u0440\u0435\u0430\u043b\u0438\u0437\u0430\u0446\u0438\u044f\">else here</a>. You don't have to (yet) be able to write them, but just understand what it is and how it works.</p>\n<p><a href=\"https://e-maxx.ru/algo/treap\">Theory on e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=\u0414\u0435\u043a\u0430\u0440\u0442\u043e\u0432\u043e_\u0434\u0435\u0440\u0435\u0432\u043e\">Theory on the ITMO website</a><br>\nYou can still Google\n</p>")),
            problem(2782),
            problem(1363),
            problem(2790),
        ], "cartesian_tree")
    }