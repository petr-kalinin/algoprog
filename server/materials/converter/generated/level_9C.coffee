import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest35711 = () ->
    return contest("9В: Дополнительные задачи на разные темы - 1", [
        problem(30),
        problem(2784),
        problem(1044),
        problem(113556),
        problem(2512),
        problem(3300),
        problem(395),
        problem(113809),
    ])

contest35712 = () ->
    return contest("9В: Дополнительные задачи на разные темы - 2", [
        problem(2821),
        problem(113563),
        problem(1650),
        problem(113775),
        problem(1049),
        problem(186),
        problem(2881),
    ])

export default level_9C = () ->
    return level("9В", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest35711(),
        contest35712(),
    ])