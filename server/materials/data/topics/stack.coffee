import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default stack = () ->
    return {
        topic: topic(
            ruen("Стек, очередь, дек", "Stack, queue, dequeue"),
            ruen("Задачи на стек, очередь и дек", "Problems on stack, queue and dequeue"),
        [label(ruen(
             "Теории по этим темам тут пока нет, но очень много теории есть в интернете. Вот, например, что я нашел: <a href=\"https://algolist.manual.ru/ds/basic/\">раз</a>, <a href=\"https://brestprog.by/topics/datastructures/\">два</a>.",
             "There is no theory on these topics here yet, but there is a lot of theory on the Internet. Here, for example, is what I found: <a href=\"https://algolist.manual.ru/ds/basic/\">one</a>, <a href=\"https://brestprog.by/topics/datastructures/\">two</a>.")),
            problem(54),
            problem(58),
            problem(61),
            problem(50),
        ], "stack"),
        advancedProblems: [
            problem(51),
            problem(112736),
            problem(52),
            problem(111648),
        ]
    }