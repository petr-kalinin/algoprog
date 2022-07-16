import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default advanced_scanline = () ->
    return {
        topic: topic(
            ruen("Продвинутый scanline", "Advanced scanline"),
            ruen("Задачи на продвинутый scanline", "Problems on advanced scanline"),
        [problem(1217),
            problem(2866),
            problem(111800),
            problem(113809),
        ], "advanced_scanline"),
        advancedProblems: [
            problem(112817)
        ]
    }