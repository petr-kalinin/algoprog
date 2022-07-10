import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default mincost_maxflow = () ->
    return {
        topic: topic(
            ruen("Mincost-maxflow", "Mincost-maxflow"),
            ruen("Задачи на mincost-maxflow", "Problems on mincost-maxflow"),
        [label(ruen(
             "<p>См. <a href=\"https://e-maxx.ru/algo/min_cost_flow\">теорию на e-maxx</a>\n</p>",
             "<p>See the <a href=\"https://e-maxx.ru/algo/min_cost_flow\">theory on e-maxx</a>\n</p>")),
            label(ruen(
                "TODO",
                "TODO")),
            problem({testSystem: "codeforces", contest: "863", problem: "F"}),
            problem({testSystem: "codeforces", contest: "818", problem: "G"}),
            problem({testSystem: "codeforces", contest: "1187", problem: "G"}),
        ], "mincost_maxflow")
    }