import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default mass_operations = () ->
    return {
        topic: topic("Групповые операции на деревьях", "Задачи на групповые операции", [
            label("<p>См. <a href=\"https://e-maxx.ru/algo/segment_tree#20\">теорию на e-maxx</a>.</p>"),
            problem(3327),
            problem(3329),
            problem(3328),
            problem(111240)
        ], "mass_operations"),
        advancedProblems: [
            problem(113563),
            problem(113775),
        ]
    }