import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default backtrack = () ->
    return {
        topic: topic("Бинарные деревья и бор", "Задачи на бинарные деревья и бор", [
            label("Теории тут пока нет"),
            label("TODO"),
            problem(111729),
        ]),
        advancedProblems: [
            problem(30),
            problem(1044),
        ]
    }