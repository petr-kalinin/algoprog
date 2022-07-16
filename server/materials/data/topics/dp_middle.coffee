import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default dp_middle = () ->
    return {
        topic: topic(
            ruen("Задачи средней сложности на ДП", "Problems of medium difficulty on DP"),
            ruen("Задачи средней сложности на ДП", "Problems of medium difficulty on DP"),
        [problem(212),
            problem(492),
            problem(587),
            problem(515),
            problem(545),
            problem(208),
            problem(1129),
        ], "dp_middle"),
        advancedProblems: [
            problem(860),
            problem(3717),
            problem(218),
            problem(1212),
            problem(215),
            problem(1254),
            problem(1106),
            problem(3892),
            problem(44),
            problem(691),
            problem(111882),
        ]
    }