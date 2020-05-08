import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_19018 = () ->
    return contest("5В: Задачи на разные темы - 2", [
        problem(1987),
        problem(218),
        problem(1212),
        problem(1782),
        problem(215),
        problem(1254),
        problem(641),
    ])

contest_19016 = () ->
    return contest("5В: Задачи на разные темы - 1", [
        problem(3871),
        problem(112567),
        problem(1967),
        problem(3350),
        problem(860),
        problem(1207),
        problem(3717),
        problem(3899),
    ])

contest_19019 = () ->
    return contest("5В: Задачи на разные темы - 3", [
        problem(1106),
        problem(583),
        problem(3892),
        problem(44),
        problem(1390),
        problem(691),
        problem(111882),
    ])

contest_39718 = () ->
    return contest("5В: Продвинутые задачи на рекурсивный перебор", [
        problem(157),
        problem(1680),
        problem(2776),
        problem(3879),
        problem(3096),
        problem(158),
        problem(159),
    ])

export default level_5C = () ->
    return level("5В", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_19016(),
        contest_19018(),
        contest_19019(),
        contest_39718(),
    ])