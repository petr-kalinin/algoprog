import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default dp_bayans = () ->
    return {
        topic: topic(
            ruen("Динамическое программирование: баяны", "Dynamic programming: classical problems"),
            ruen("ДП-баяны", "DP-classics"),
        [label(ruen(
             "Есть ряд классических задач на динамическое программирование, которые хорошо бы знать наизусть. Большинство этих задач разобраны в теории про ДП на уровне 2. В контесте ниже, помимо этих баянов, есть еще несколько интересных задач на ДП.",
             "There are a number of classic dynamic programming problems that it would be good to know by heart. Most of these tasks are discussed in the theory about DP on level 2. In the contest below, in addition to these classical problems, there are several other interesting DP problems.")),
            problem(204),
            problem(1792),
            problem(112626),
            problem(1791),
            problem(1124),
            problem(3005),
            problem(2962),
        ], "dp_bayans"),
        advancedProblems: [
            problem(217),
            problem(1095),
            problem(3001),
        ]
    }