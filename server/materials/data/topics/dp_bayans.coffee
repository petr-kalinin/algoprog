import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default dp_bayans = () ->
    return {
        topic: topic("Динамическое программирование: баяны", "ДП-баяны", [
            label("Есть ряд классических задач на динамическое программирование, которые хорошо бы знать наизусть. Большинство этих задач разобраны в теории про ДП выше. В контесте ниже, помимо этих баянов, есть еще несколько интересных задач на ДП."),
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