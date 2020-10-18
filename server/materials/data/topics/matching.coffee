import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default matching = () ->
    return {
        topic: topic("Паросочетания и связанные темы", "Задачи на паросочетания", [
            label("<p><a href=\"https://e-maxx.ru/algo/kuhn_matching\">Теория на e-maxx</a><br>\nДополнительный (но важный) материал на вики ИТМО: <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Связь_максимального_паросочетания_и_минимального_вершинного_покрытия_в_двудольных_графах\">раз</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Связь_вершинного_покрытия_и_независимого_множества\">два</a>.<br>\nНа тему связи паросочетания, независимого множества и вершинного покрытия можете еще поискать в интернете, если в конспекте ИТМО непонятно.</p>"),
            problem(1683),
            problem(588),
            problem(4204),
            problem(111663),
        ], "matching"),
        advancedProblems: [
            problem(111757),
            problem(112571),
            problem(111733),
        ]
    }