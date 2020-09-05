import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default backtrack = () ->
    return {
        topic: topic("Битовые операции", "Задачи на битовые операции", [
            label("Теории тут пока нет."),
            problem(123),
            problem(128),
            problem(111588),
        ]),
        advancedProblems: [
            problem(111521),
            problem(122),
        ]
    }