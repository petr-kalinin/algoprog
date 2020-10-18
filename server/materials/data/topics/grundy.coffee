import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default grundy = () ->
    return {
        topic: topic("Функция Гранди", "Задачи на функцию Гранди", [
            label("<p><a href=\"https://e-maxx.ru/algo/sprague_grundy\">Теория на e-maxx</a><br>\n<a href=\"https://habrahabr.ru/post/124856/\">Теория на хабре</a><br>\n<a>Можете еще в интернете поискать</a></p>"),
            problem(369),
            problem(905),
            problem(2916),
        ], "grundy")
    }