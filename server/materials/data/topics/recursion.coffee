import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default recursion = () ->
    return {
        topic: topic("Рекурсия", "Задачи на рекурсию", [
            label("Теории тут пока нет, почитайте в книжке или спросите меня."),
            problem(153),
            problem(154)
            problem(113656),
            problem({testSystem: "ejudge", contest: "2001", problem: "2"}),
            problem(3050)
        ]),
        advancedProblems: [
            problem(1414),
        ]
    }