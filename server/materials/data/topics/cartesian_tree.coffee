import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default cartesian_tree = () ->
    return {
        topic: topic("Декартово дерево", "Задачи на декартовы деревья", [
            label("<p>Для начала почитайте про <a href=\"https://ru.wikipedia.org/wiki/Двоичное_дерево_поиска\">двоичные деревья поиска</a>, ну или <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Дерево_поиска%2C_наивная_реализация\">еще здесь</a>. Вам не обязательно (пока) уметь их писать, но просто поймите, что это такое и с чем его едят.</p>\n<p><a href=\"https://e-maxx.ru/algo/treap\">Теория на e-maxx</a><br>\n<a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Декартово_дерево\">Теория на сайте ИТМО</a><br>\n<a href=\"https://www.mkurnosov.net/teaching/uploads/DSA/dsa-fall2014-lec7.pdf\">Еще какая-то теория</a><br>\n<a href=\"https://opentrains.mipt.ru/zksh/files/zksh2015/lectures/zksh_cartesian.pdf\">Еще какая-то теория</a><br>\nМожете еще погуглить\n</p>"),
            problem(2782),
            problem(1363),
            problem(2790),
        ], "cartesian_tree")
    }