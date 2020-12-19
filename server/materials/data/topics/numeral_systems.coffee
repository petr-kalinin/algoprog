import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default numeral_systems = () ->
    return {
        topic: topic("Системы счисления. Двоичная система счисления.", "Задачи на системы счисления", [
            label("Теории тут пока нет, можете поискать в интернете (я нашел <a href=\"https://ru.wikibooks.org/wiki/%D0%A1%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B_%D1%81%D1%87%D0%B8%D1%81%D0%BB%D0%B5%D0%BD%D0%B8%D1%8F\">раз</a>, <a href=\"https://habrahabr.ru/post/124395/\">два</a>). Вам нужно понимание того, как работают позиционные системы счисления, и как переводить числа из одной системы в другую."),
            problem(117),
            problem(344),
            problem(47),
            problem(1367),
            problem(46),
        ], "numeral_systems"),
        advancedProblems: [
            problem(245),
            problem(111584)
        ]
    }