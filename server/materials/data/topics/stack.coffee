import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default stack = () ->
    return {
        topic: topic("Стек, дек, очередь", "Задачи на стек, очередь и дек", [
            label("Теории по этим темам тут пока нет, но очень много теории есть в интернете. Вот, например, что я нашел: <a href=\"https://algolist.manual.ru/ds/basic/\">раз</a>, <a href=\"https://brestprog.by/topics/datastructures/\">два</a>."),
            problem(54),
            problem(58),
            problem(61),
            problem(50),
        ]),
    }