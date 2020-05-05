import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest39869 = () ->
    return contest("10В: Дополнительные задачи на разные темы", [
        problem(3887),
        problem(111597),
        problem(113932),
        problem(519),
        problem(111500),
        problem(3894),
        problem(19),
        problem(3400),
        problem(111828),
    ])

export default level_10C = () ->
    return level("10В", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest39869(),
    ])