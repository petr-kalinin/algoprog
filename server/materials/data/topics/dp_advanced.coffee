import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default dp_advanced = () ->
    return {
        topic: topic("Сложные задачи на ДП", "Сложные задачи на ДП", [
            problem(1793),
            problem(1720),
            problem(3898),
            problem(111490),
        ], "dp_advanced"),
        additionalProblems: [
            problem(11),
            problem(16),
            problem(2534),
        ]
    }