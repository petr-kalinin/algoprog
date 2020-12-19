import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

contest_1 = () ->
    return contest("Дополнительные задачи на разные темы  - 1", [
        problem({testSystem: "codeforces", contest: "653", problem: "D"}),
        problem({testSystem: "codeforces", contest: "650", problem: "C"}),
        problem({testSystem: "codeforces", contest: "620", problem: "E"}),
        problem({testSystem: "codeforces", contest: "620", problem: "D"}),
        problem({testSystem: "codeforces", contest: "618", problem: "D"}),
        problem({testSystem: "codeforces", contest: "617", problem: "E"}),
    ])

contest_2 = () ->
    return contest("Дополнительные задачи на разные темы - 2", [
        problem({testSystem: "codeforces", contest: "616", problem: "E"}),
        problem({testSystem: "codeforces", contest: "615", problem: "E"}),
        problem({testSystem: "codeforces", contest: "612", problem: "E"}),
        problem({testSystem: "codeforces", contest: "609", problem: "E"}),
        problem({testSystem: "codeforces", contest: "603", problem: "C"}),
        problem({testSystem: "codeforces", contest: "601", problem: "B"}),
    ])

contest_3 = () ->
    return contest("Дополнительные задачи на разные темы - 3", [
        problem({testSystem: "codeforces", contest: "593", problem: "C"}),
        problem({testSystem: "codeforces", contest: "592", problem: "D"}),
        problem({testSystem: "codeforces", contest: "590", problem: "C"}),
        problem({testSystem: "codeforces", contest: "590", problem: "B"}),
        problem({testSystem: "codeforces", contest: "587", problem: "C"}),
        problem({testSystem: "codeforces", contest: "587", problem: "B"}),
    ])

export default level_11D = () ->
    return level("11Г", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум треть задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_1(),
        contest_2(),
        contest_3(),
    ])