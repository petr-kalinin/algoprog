import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default sorting = () ->
    return {
        topic:     topic("Квадратичные сортировки", "2А: Задачи на квадратичные сортировки", [
            label("Видеозаписи лекций ЛКШ по сортировкам: <a href=\"https://sis.khashaev.ru/2013/august/c-prime/kBHwr_e_aAg/\">сортировка пузырьком</a>, <a href=\"https://sis.khashaev.ru/2013/august/c-prime/gZGwKXwjffg/\">выбором максимума</a>. К сожалению, теории по сортировкой вставками тут пока нет. Найдите в интернете или прослушайте на занятии."),
            label("Внимание! В задаче \"Библиотечный метод\" надо выводить очередную строку только если состояние массива при этой вставке изменилось."),
            problem(230),
            problem(1436),
            problem(1411),
            problem(1099),
            problem(39),
        ]),
        advancedTopics: [
        ]
    }