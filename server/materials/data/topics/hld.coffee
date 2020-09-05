import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default hld = () ->
    return {
        topic: topic("Heavy-light decomposition", "Задачи на HLD", [
            label("TODO"),
            problem(80),
        ]),
    }