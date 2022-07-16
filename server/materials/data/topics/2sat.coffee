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
            ruen("2-SAT", "2-SAT"),
            ruen("Задачи на 2-SAT", "Problems on 2-SAT"),
        [label(ruen(
             "<a href='https://e-maxx.ru/algo/2_sat'>Теория на e-maxx</a>",
             "<a href=\"https://e-maxx.ru/algo/2_sat\">Theory on e-maxx</a>")),
            problem({testSystem: "codeforces", contest: "587", problem: "D"}),
            problem({testSystem: "codeforces", contest: "568", problem: "C"}),
            problem({testSystem: "codeforces", contest: "1239", problem: "D"}),
        ], 
        "2sat"),
        advancedProblems: [
            problem(113793)
            problem({testSystem: "codeforces", contest: "1215", problem: "F"}),
        ]
    }