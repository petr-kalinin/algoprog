import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

contest_1 = () ->
    return contest("Дополнительные задачи на разные темы  - 1", [
        problem({testSystem: "codeforces", contest: "687", problem: "C"}),
        problem({testSystem: "codeforces", contest: "685", problem: "B"}),
        problem({testSystem: "codeforces", contest: "682", problem: "D"}),
        problem({testSystem: "codeforces", contest: "681", problem: "D"}),
        problem({testSystem: "codeforces", contest: "676", problem: "D"}),
        problem({testSystem: "codeforces", contest: "671", problem: "B"}),
    ])

contest_2 = () ->
    return contest("Дополнительные задачи на разные темы - 2", [
        problem({testSystem: "codeforces", contest: "666", problem: "B"}),
        problem({testSystem: "codeforces", contest: "662", problem: "D"}),
        problem({testSystem: "codeforces", contest: "660", problem: "D"}),
        problem({testSystem: "codeforces", contest: "659", problem: "F"}),
        problem({testSystem: "codeforces", contest: "653", problem: "C"}),
        problem({testSystem: "codeforces", contest: "650", problem: "B"}),
    ])

contest_3 = () ->
    return contest("Дополнительные задачи на разные темы - 3", [
        problem({testSystem: "codeforces", contest: "641", problem: "E"}),
        problem({testSystem: "codeforces", contest: "633", problem: "D"}),
        problem({testSystem: "codeforces", contest: "633", problem: "C"}),
        problem({testSystem: "codeforces", contest: "630", problem: "O"}),
        problem({testSystem: "codeforces", contest: "629", problem: "D"}),
        problem({testSystem: "codeforces", contest: "622", problem: "D"}),
    ])

export default level_9D = () ->
    return level("9Г", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум треть задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_1(),
        contest_2(),
        contest_3(),
    ])