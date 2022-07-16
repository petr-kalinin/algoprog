import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default persistency = () ->
    return {
        topic: topic(
            ruen("Персистентные структуры данных", "Persistent data structures"),
            ruen("Задачи на персистентные структуры данных", "Problems on persistent data structures"),
        [problem(114323),
            problem(1817)
            problem(2980)
            problem(111614)
            problem({testSystem: "codeforces", contest: "1000", problem: "F"}),
        ], "persistency"),
    }