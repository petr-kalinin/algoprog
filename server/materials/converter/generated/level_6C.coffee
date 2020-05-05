import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest19486 = () ->
    return contest("6В: Дополнительные задачи на разные темы - 1", [
        problem(1350),
        problem(435),
        problem(2806),
        problem(173),
        problem(1349),
        problem(1995),
        problem(3870),
        problem(493),
    ])

contest19487 = () ->
    return contest("6В: Дополнительные задачи на разные темы - 2", [
        problem(112448),
        problem(2598),
        problem(441),
        problem(112445),
        problem(3099),
    ])

export default level_6C = () ->
    return level("6В", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest19486(),
        contest19487(),
    ])