import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default games_cyclic = () ->
    return {
        topic: topic(
            ruen("Игры на циклических графах", "Games on cyclic graphs"),
            ruen("Задачи на игры на циклических графах", "Problems on games on cyclic graphs"),
        [problem(3390),
            problem({testSystem: "codeforces", contest: "787", problem: "C"}),
        ], "games_cyclic"),
    }