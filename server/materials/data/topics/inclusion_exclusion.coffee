import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default two_sat = () ->
    return {
        topic: topic("Формула включения-исключения", "Задачи на формулу включения-исключения", [
            label("TODO"),
            problem(552),
        ], "inclusion_exclusion"),
        advancedProblems: [
            problem({testSystem: "codeforces", contest: "585", problem: "E"}),
        ]
    }