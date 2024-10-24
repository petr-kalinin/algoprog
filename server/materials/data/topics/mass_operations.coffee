import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default mass_operations = () ->
    return {
        topic: topic(
            ruen("Групповые операции на деревьях", "Group operations on trees"),
            ruen("Задачи на групповые операции", "Problems on group operations"),
        [label(ruen(
             "<p>См. <a href=\"https://e-maxx.ru/algo/segment_tree#20\">теорию на e-maxx</a>.</p>",
             "<p>See the <a href=\"https://e-maxx.ru/algo/segment_tree#20\">theory on e-maxx</a>.</p>")),
            problem(3327),
            problem(3329),
            problem(1364),
            problem(3328),
            problem(111240)
        ], "mass_operations"),
        advancedProblems: [
            problem(113563),
            problem(113775),
            problem(113287),
        ]
    }
