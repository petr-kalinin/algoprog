import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"


export default stl = () ->
    return {
        topic: topic("*Стандартные структуры данных (STL и т.п.) ", "*Задачи на стандартные структуры данных", [
            label("Тема не обязательная, но будет полезна в дальнейшем. Касается всех языков, кроме паскаля. Теории тут нет, спросите меня."),
            problem(112536),
        ]),
        count: false
    }