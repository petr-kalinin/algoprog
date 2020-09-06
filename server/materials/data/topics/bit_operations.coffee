import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default bit_operations = () ->
    return {
        topic: topic("Битовые операции", "Задачи на битовые операции", [
            label("Теории тут пока нет."),
            problem(123),
            problem(128),
            problem(111588),
            # TODO: Две одинаковые буквы без массивов (надо задвоить задачу)
        ]),
        advancedProblems: [
            problem(111521),
            problem(122),
            problem({testSystem: "codeforces", contest: "1303", problem: "D"}),
        ]
    }