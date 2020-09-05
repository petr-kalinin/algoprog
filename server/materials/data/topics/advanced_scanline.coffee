import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default advanced_scanline = () ->
    return {
        topic: topic("Продвинутый scanline", "Задачи на продвинутый scanline", [
            label("TODO"),
            problem(80),
        ]),
    }