import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default geometry_advanced = () ->
    return {
        topic: topic(
            ruen("Сложная геометрия", "Advanced geometry"),
            ruen("Задачи на сложную геометрию", "Problems on advanced geometry"),
        [problem(34),
            problem(923),
            problem(1109),
            problem(111780),
            problem(1360),
            problem(1128),
            problem(3209),
        ], "geometry_advanced"),
        advancedProblems: [
            problem(519),
            problem(111500),
            problem(3894),
            problem(19),
            problem(3400),
            problem(111828),
        ]
    }