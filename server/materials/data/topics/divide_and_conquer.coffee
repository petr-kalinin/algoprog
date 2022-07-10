import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default divide_and_conquer = () ->
    return {
        topic: topic(
            ruen("Разделяй и влавствуй", "Divide and conquer"),
            ruen("Задачи на разделяй и влавствуй", "Problems on divide and conquer"),
        [label(ruen(
             "TODO",
             "TODO")),
            problem({testSystem: "codeforces", contest: "429", problem: "D"}),
            problem({testSystem: "codeforces", contest: "120", problem: "J"}),
            #problem({testSystem: "codeforces", contest: "100273", problem: "A"}),  # TODO
        ], "divide_and_conquer"),
    }