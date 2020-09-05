import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default mincost_maxflow = () ->
    return {
        topic: topic("Mincost-maxflow", "Задачи на mincost-maxflow", [
            label("<p>См. <a href=\"https://e-maxx.ru/algo/min_cost_flow\">теорию на e-maxx</a>\n</p>\n<p>Я не нашел на информатиксе задач на эту тему :(</p>"),
            label("TODO"),
            problem(80)
        ])
    }