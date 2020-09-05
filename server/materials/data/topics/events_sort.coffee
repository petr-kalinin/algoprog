import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default events_sort = () ->
    return {
        topic: topic("Сортировка событий", "Задачи на сортировку событий", [
            label("Теории тут пока нет, прослушайте на занятии (попросите меня рассказать)."),
            problem(112542),
            problem(1755),
            problem(3721),
            problem(1338),
            problem(111790),
        ])
    }