import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default hld = () ->
    return {
        topic: topic(
            ruen("Heavy-light decomposition", "Heavy-light decomposition"),
            ruen("Задачи на HLD", "Problems on HLD"),
        [label(ruen(
             "TODO",
             "TODO")),
            label(ruen(
                "<a href='https://codeforces.com/blog/entry/44351'>Еще теория</a>",
                "<a href=\"https://codeforces.com/blog/entry/44351\">Another theory</a>"))
            problem({testSystem: "codeforces", contest: "600", problem: "E"}),
            problem({testSystem: "codeforces", contest: "570", problem: "D"}),
            problem({testSystem: "codeforces", contest: "246", problem: "E"}),
        ], "hld"),
        advancedProblems: [
            problem({testSystem: "codeforces", contest: "208", problem: "E"}),
            problem({testSystem: "codeforces", contest: "291", problem: "E"}),
        ]
    }