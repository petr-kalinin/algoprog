import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default matching = () ->
    return {
        topic: topic(
            ruen("Паросочетания и связанные темы", "Maximal matching and related topics"),
            ruen("Задачи на паросочетания", "Problems on matching"),
        [label(ruen(
             "<p><a href=\"https://e-maxx.ru/algo/kuhn_matching\">Теория на e-maxx</a><br>\nДополнительный (но важный) материал на вики ИТМО: <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Связь_максимального_паросочетания_и_минимального_вершинного_покрытия_в_двудольных_графах\">раз</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=Связь_вершинного_покрытия_и_независимого_множества\">два</a>.<br>\nНа тему связи паросочетания, независимого множества и вершинного покрытия можете еще поискать в интернете, если в конспекте ИТМО непонятно.</p>",
             "<p><a href=\"https://e-maxx.ru/algo/kuhn_matching\">Theory on e-maxx</a><br>\nAdditional (but important) material on the ITMO wiki: <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=\u0421\u0432\u044f\u0437\u044c_\u043c\u0430\u043a\u0441\u0438\u043c\u0430\u043b\u044c\u043d\u043e\u0433\u043e_\u043f\u0430\u0440\u043e\u0441\u043e\u0447\u0435\u0442\u0430\u043d\u0438\u044f_\u0438_\u043c\u0438\u043d\u0438\u043c\u0430\u043b\u044c\u043d\u043e\u0433\u043e_\u0432\u0435\u0440\u0448\u0438\u043d\u043d\u043e\u0433\u043e_\u043f\u043e\u043a\u0440\u044b\u0442\u0438\u044f_\u0432_\u0434\u0432\u0443\u0434\u043e\u043b\u044c\u043d\u044b\u0445_\u0433\u0440\u0430\u0444\u0430\u0445\">one</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=\u0421\u0432\u044f\u0437\u044c_\u0432\u0435\u0440\u0448\u0438\u043d\u043d\u043e\u0433\u043e_\u043f\u043e\u043a\u0440\u044b\u0442\u0438\u044f_\u0438_\u043d\u0435\u0437\u0430\u0432\u0438\u0441\u0438\u043c\u043e\u0433\u043e_\u043c\u043d\u043e\u0436\u0435\u0441\u0442\u0432\u0430\">two</a>.<br>\nYou can also search on the Internet about the connection of maximal matching,  independent set and vertex cover.</p>")),
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