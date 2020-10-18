import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default divide_and_conquer = () ->
    return {
        topic: topic("Разделяй и влавствуй", "Задачи на разделяй и влавствуй", [
            label("TODO"),
            problem({testSystem: "codeforces", contest: "429", problem: "D"}),
            problem({testSystem: "codeforces", contest: "120", problem: "J"}),
            #problem({testSystem: "codeforces", contest: "100273", problem: "A"}),  # TODO
        ], "divide_and_conquer"),
    }