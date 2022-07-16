import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default grundy = () ->
    return {
        topic: topic(
            ruen("Функция Гранди", "Grundi's function"),
            ruen("Задачи на функцию Гранди", "Problems on grundy function"),
        [label(ruen(
             "<p><a href=\"https://e-maxx.ru/algo/sprague_grundy\">Теория на e-maxx</a><br>\n<a href=\"https://habrahabr.ru/post/124856/\">Теория на хабре</a><br>\nМожете еще в интернете поискать</p>",
             "<p><a href=\"https://e-maxx.ru/algo/sprague_grundy\">Theory on e-maxx</a><br>\n<a href=\"https://habrahabr.ru/post/124856/\">Theory on habr</a><br>\nYou can also search the Internet</p>")),
            problem(369),
            problem(905),
            problem(2916),
        ], "grundy")
    }