import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default hash = () ->
    return {
        topic: topic("Хеширование", "Задачи на хеширование", [
            label("Основной теории тут пока нет, поищите в интернете.<br>\nДополнительная теория (предполагает, что вы уже почитали основную теорию): <a href=\"https://blog.algoprog.ru/hash-no-multiply\">как писать хеширование без домножения</a>.<br>\nЕще полезное <a href=\"https://codeforces.com/blog/entry/4898\">про антихештесты</a>."),
            problem(99),
            problem(100),
            problem(1042),
            problem(1943),
            problem(1326),
        ], "hash"),
        advancedProblems: [
            problem(3871),
            problem(112567),
            problem(3899),
            problem(1390),
        ]
    }