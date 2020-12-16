import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default games_cyclic = () ->
    return {
        topic: topic("Игры на циклических графах", "Задачи на игры на циклических графах", [
            problem(3390),
            problem({testSystem: "codeforces", contest: "787", problem: "C"}),
        ], "games_cyclic"),
    }