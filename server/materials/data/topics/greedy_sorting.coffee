import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default greedy_sorting = () ->
    return {
        topic: topic("Применения сортировки", "Задачи на применение сортировок", [
            label("<p>Теории тут нет, спросите на занятии</p>"),
            problem(411),
            problem(734),
            problem(1130),
            problem(1744),
            problem(2978),
        ])
    }