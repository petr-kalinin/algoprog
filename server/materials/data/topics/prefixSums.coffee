import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default prefixSums = () ->
    return {
        topic: topic("Префиксные суммы", "Задачи на префиксные суммы", [
            label("Идея простая, но легкой теории я с ходу не нашел. Можете почитать по следующим ссылкам: <a href='https://brestprog.by/topics/prefixsums/'>раз</a>, <a href='https://silvertests.ru/GuideView.aspx?id=31909'>два</a>, <a href='https://ru.wikipedia.org/wiki/Префиксная_сумма'>три</a>, или спросить меня."),
            problem(2771),
            problem(2772),
            problem(3313),
            problem(112735)
        ]),
        advancedProblems: [
            problem(112745),
            problem(2774),
            problem(111121)

            # Not a prefixSum problem
            problem(1460),
        ]
    }