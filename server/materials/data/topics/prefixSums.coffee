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
             "USACO guide: <a href=\"https://usaco.guide/silver/prefix-sums\">part one</a>, <a href=\"https://usaco.guide/silver/more-prefix-sums\">part two</a>,<br/>
             <a href=\"https://medium.com/codefight-on/prefix-sums-2128ea7c51d0\">Some other theory on prefix sums</a><br/>
             You would also need prefix maximums in the problems below.")),
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