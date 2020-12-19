import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

contest_1 = () ->
    return contest("Дополнительные задачи на разные темы  - 1", [
        problem({testSystem: "codeforces", contest: "732", problem: "D"}),
        problem({testSystem: "codeforces", contest: "761", problem: "D"}),
        problem({testSystem: "codeforces", contest: "758", problem: "C"}),
        problem({testSystem: "codeforces", contest: "729", problem: "D"}),
        problem({testSystem: "codeforces", contest: "727", problem: "D"}),
        problem({testSystem: "codeforces", contest: "725", problem: "D"}),
    ])

contest_2 = () ->
    return contest("Дополнительные задачи на разные темы - 2", [
        problem({testSystem: "codeforces", contest: "724", problem: "C"}),
        problem({testSystem: "codeforces", contest: "721", problem: "C"}),
        problem({testSystem: "codeforces", contest: "718", problem: "A"}),
        problem({testSystem: "codeforces", contest: "711", problem: "C"}),
        problem({testSystem: "codeforces", contest: "706", problem: "D"}),
        problem({testSystem: "codeforces", contest: "700", problem: "B"}),
    ])

contest_3 = () ->
    return contest("Дополнительные задачи на разные темы - 3", [
        problem({testSystem: "codeforces", contest: "698", problem: "B"}),
        problem({testSystem: "codeforces", contest: "696", problem: "B"}),
        problem({testSystem: "codeforces", contest: "691", problem: "D"}),
        problem({testSystem: "codeforces", contest: "691", problem: "C"}),
        problem({testSystem: "codeforces", contest: "765", problem: "D"}),
        problem({testSystem: "codeforces", contest: "689", problem: "C"}),
    ])

export default level_7D = () ->
    return level("7Г", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум треть задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_1(),
        contest_2(),
        contest_3(),
    ])