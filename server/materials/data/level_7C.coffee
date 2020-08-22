import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

contest_25536 = () ->
    return contest("7В: Дополнительные задачи на разные темы - 1", [
        problem(112567),
        problem(3320),
        problem(21),
        problem(3388),
        problem(3568),
        problem(112597),
        problem(112096),
    ])

contest_25537 = () ->
    return contest("7В: Дополнительные задачи на разные темы - 2", [
        problem(3318),
        problem(998),
        problem(111744),
        problem(1746),
        problem(757),
        problem(573),
    ])

export default level_7C = () ->
    return level("7В", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_25536(),
        contest_25537(),
    ])