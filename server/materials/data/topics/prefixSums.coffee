import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default prefixSums = () ->
    return {
        topic: topic("Префиксные суммы и смежные темы", "Задачи на префиксные суммы", [
            label("<a href='https://notes.algoprog.ru/shortideas/03_x_prefix_sums.html'>Теория по префиксным суммам и смежным темам</a>"),
            problem(2771),
            problem(2772),
            problem(3313),
            problem(112735)
        ], "prefix_sums"),
        advancedProblems: [
            problem(112745),
            problem(2774),
            problem(111121)

            # Not a prefixSum problem
            problem(1460),
        ]
    }