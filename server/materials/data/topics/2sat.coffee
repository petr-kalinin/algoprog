import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default two_sat = () ->
    return {
        topic: topic("2-SAT", "Задачи на 2-SAT", [
            label("TODO"),
            problem(80),
        ]),
    }