import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default prefixSums = () ->
    return {
        topic: topic(
            ruen("Префиксные суммы и смежные темы", "Prefix sums and related topics"),
            ruen("Задачи на префиксные суммы", "Problems on prefix sums"),
        [label(ruen(
             "<a href='https://notes.algoprog.ru/shortideas/03_x_prefix_sums.html'>Теория по префиксным суммам и смежным темам</a>",
             "<a href=\"https://notes.algoprog.ru/shortideas/03_x_prefix_sums.html\">Theory on prefix sums and related topics</a>")),
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