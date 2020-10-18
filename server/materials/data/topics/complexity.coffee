import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default complexity = () ->
    return {
        topic: topic("Сложность алгоритмов", null, [
            label("<a href=\"https://notes.algoprog.ru/complexity/index.html\">Теория про сложность алгоритмов (самое важное в разделе «O-обозначение для оценки сложности алгоритмов»; про P и NP читать не обязательно)</a>"),
        ], "complexity"),
        count: false
    }
