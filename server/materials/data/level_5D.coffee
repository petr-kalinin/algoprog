import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

contest_1 = () ->
    return contest("Дополнительные задачи на разные темы  - 1", [
        problem({testSystem: "codeforces", contest: "908", problem: "C"}),
        problem({testSystem: "codeforces", contest: "906", problem: "A"}),
        problem({testSystem: "codeforces", contest: "901", problem: "A"}),
        problem({testSystem: "codeforces", contest: "898", problem: "E"}),
        problem({testSystem: "codeforces", contest: "858", problem: "D"}),
        problem({testSystem: "codeforces", contest: "856", problem: "A"}),
    ])

contest_2 = () ->
    return contest("Дополнительные задачи на разные темы - 2", [
        problem({testSystem: "codeforces", contest: "891", problem: "A"}),
        problem({testSystem: "codeforces", contest: "888", problem: "D"}),
        problem({testSystem: "codeforces", contest: "887", problem: "C"}),
        problem({testSystem: "codeforces", contest: "884", problem: "C"}),
        problem({testSystem: "codeforces", contest: "993", problem: "A"}),
        problem({testSystem: "codeforces", contest: "878", problem: "A"}),
    ])

contest_3 = () ->
    return contest("Дополнительные задачи на разные темы - 3", [
        problem({testSystem: "codeforces", contest: "877", problem: "C"}),
        problem({testSystem: "codeforces", contest: "877", problem: "B"}),
        problem({testSystem: "codeforces", contest: "875", problem: "B"}),
        problem({testSystem: "codeforces", contest: "873", problem: "C"}),
        problem({testSystem: "codeforces", contest: "873", problem: "B"}),
        problem({testSystem: "codeforces", contest: "868", problem: "C"}),
    ])

export default level_5D = () ->
    return level("5Г", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум треть задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_1(),
        contest_2(),
        contest_3(),
    ])