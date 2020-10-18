import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default dp_middle = () ->
    return {
        topic: topic("Задачи средней сложности на ДП", "Задачи средней сложности на ДП", [
            problem(212),
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