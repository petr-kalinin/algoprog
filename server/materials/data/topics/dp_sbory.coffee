import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default dp_sbory = () ->
    return {
        topic: topic("*Доп. задачи на ДП", "*Дополнительные задачи на ДП", [
            label("Это задачи на ДП с зимних сборов алгопрога 2021. Раздел не обязательный. Сложность задач очень разная.")
            problem(498),
            problem(44),
            problem(631),
            problem(691),
            problem(217),
            problem(1212),
            problem(24),
            problem(571),
            problem(78),
            problem({testSystem: "ejudge", contest: "3001", problem: "2"}),
            problem({testSystem: "ejudge", contest: "3001", problem: "1"}),
        ], "dp_sbory"),
        count: 0
    }