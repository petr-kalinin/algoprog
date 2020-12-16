import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default maxmatching = () ->
    return {
        topic: topic("Паросочетание максимального веста, венгерский алгоритм", "Задачи на венгерский алгоритм", [
            label("<p>См.\n<a href=\"https://e-maxx.ru/algo/assignment_hungary\">теорию на e-maxx</a>, но <a href=\"https://e-maxx.ru/algo/assignment_mincostflow\">можно писать и mincost-maxflow</a>.\n</p>"),
            problem(111556),
            problem({testSystem: "codeforces", contest: "1107", problem: "F"}),
        ], "maxmatching")
    }