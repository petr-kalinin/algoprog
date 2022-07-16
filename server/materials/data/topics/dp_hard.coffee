import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default dp_hard = () ->
    return {
        topic: topic(
            ruen("Супер-сложное ДП", "Super-difficult DP"),
            ruen("Задачи на супер-сложное ДП", "Problems on super-difficult DP"),
        [label(ruen(
             "<a href='https://codeforces.com/blog/entry/63823'>Полезный прием: convex hull trick</a>",
             "<a href=\"https://codeforces.com/blog/entry/63823\">Useful technique: convex hull trick</a>")),
            problem({testSystem: "codeforces", contest: "1083", problem: "E"}),
            problem({testSystem: "codeforces", contest: "319", problem: "C"}),
            problem({testSystem: "codeforces", contest: "311", problem: "B"}),
        ], "dp_hard"),
        advancedProblems: [
            problem({testSystem: "codeforces", contest: "631", problem: "E"}),
            problem({testSystem: "codeforces", contest: "1388", problem: "E"}),
            problem({testSystem: "codeforces", contest: "932", problem: "F"}),
        ]
    }