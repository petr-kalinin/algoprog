import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default complexity = () ->
    return {
        topic: topic(
            ruen("Сложность алгоритмов", "Complexity of algorithms"),
            null,
        [label(ruen(
                "<a href=\"https://notes.algoprog.ru/complexity/index.html\">Теория про сложность алгоритмов (читайте раздел «Простейшие основы», остальное пока не так важно)</a>",
                "<a href=\"https://notes.algoprog.ru/complexity/index.html\">Theory on the complexity of algorithms (read the section \"The simplest basics\", the rest is not so important yet)</a>")),
        ], "complexity"),
        count: false
    }
