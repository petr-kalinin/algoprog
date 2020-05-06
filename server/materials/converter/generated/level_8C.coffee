import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_26208 = () ->
    return contest("8В: Дополнительные задачи на разные темы - 2", [
        problem(571),
        problem(112571),
        problem(1109),
        problem(455),
        problem(2916),
        problem(397),
        problem(111733),
        problem(2534),
    ])

contest_26207 = () ->
    return contest("8В: Дополнительные задачи на разные темы - 1", [
        problem(11),
        problem(488),
        problem(111757),
        problem(2786),
        problem(111749),
        problem(16),
        problem(493),
        problem(2866),
    ])

export default level_8C = () ->
    return level("8В", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_26207(),
        contest_26208(),
    ])