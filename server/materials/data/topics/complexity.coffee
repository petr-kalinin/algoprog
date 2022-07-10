import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default complexity = () ->
    return {
        topic: topic("Сложность алгоритмов", null, [
            label("<a href=\"https://notes.algoprog.ru/complexity/index.html\">Теория про сложность алгоритмов (читайте раздел «Простейшие основы», остальное пока не так важно)</a>"),
        ], "complexity"),
        count: false
    }
