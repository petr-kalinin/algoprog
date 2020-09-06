import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

contest_1 = () ->
    return contest("Дополнительные задачи на разные темы  - 1", [
        problem({testSystem: "codeforces", contest: "928", problem: "B"}),
        problem({testSystem: "codeforces", contest: "928", problem: "A"}),
        problem({testSystem: "codeforces", contest: "926", problem: "A"}),
        problem({testSystem: "codeforces", contest: "924", problem: "A"}),
        problem({testSystem: "codeforces", contest: "922", problem: "B"}),
        problem({testSystem: "codeforces", contest: "922", problem: "A"}),
    ])

contest_2 = () ->
    return contest("Дополнительные задачи на разные темы - 2", [
        problem({testSystem: "codeforces", contest: "920", problem: "C"}),
        problem({testSystem: "codeforces", contest: "920", problem: "B"}),
        problem({testSystem: "codeforces", contest: "919", problem: "C"}),
        problem({testSystem: "codeforces", contest: "915", problem: "B"}),
        problem({testSystem: "codeforces", contest: "914", problem: "B"}),
        problem({testSystem: "codeforces", contest: "913", problem: "B"}),
    ])

contest_3 = () ->
    return contest("Дополнительные задачи на разные темы - 3", [
        problem({testSystem: "codeforces", contest: "912", problem: "B"}),
        problem({testSystem: "codeforces", contest: "911", problem: "C"}),
        problem({testSystem: "codeforces", contest: "911", problem: "B"}),
        problem({testSystem: "codeforces", contest: "909", problem: "B"}),
        problem({testSystem: "codeforces", contest: "908", problem: "B"}),
        problem({testSystem: "codeforces", contest: "907", problem: "B"}),
    ])

export default level_3D = () ->
    return level("3Г", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум треть задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_1(),
        contest_2(),
        contest_3(),
    ])