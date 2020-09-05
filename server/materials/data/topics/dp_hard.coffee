import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default two_sat = () ->
    return {
        topic: topic("Супер-сложное ДП", "Задачи на супер-сложное ДП", [
            label("TODO"),
            problem(80),
        ]),
    }