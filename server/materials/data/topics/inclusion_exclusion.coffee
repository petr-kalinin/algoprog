import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default two_sat = () ->
    return {
        topic: topic(
            ruen("Формула включения-исключения", "Inclusion-exclusion formula"),
            ruen("Задачи на формулу включения-исключения", "Problems on the inclusion-exclusion formula"),
        [label(ruen(
             "TODO",
             "TODO")),
            problem(552),
        ], "inclusion_exclusion"),
        advancedProblems: [
            problem({testSystem: "codeforces", contest: "585", problem: "E"}),
        ]
    }