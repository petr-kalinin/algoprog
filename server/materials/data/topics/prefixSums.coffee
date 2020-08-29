import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default prefixSums = () ->
    return {
        topic: topic("Префиксные суммы", "Задачи на префиксные суммы", [
            label("Теории тут пока нет, спросите меня."),
            problem(2771),
            problem(2772),
            problem(3313),
            problem(112735)
        ]),
        advancedProblems: [
            problem(112745),
            problem(2774),
            problem(111121)

            # Not a prefixSum problem
            problem(1460),

        ]
    }