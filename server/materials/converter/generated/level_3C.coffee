import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_16375 = () ->
    return contest("3В: Дополнительные задачи на разные темы - 1", [
        problem(672),
        problem(1030),
        problem(1190),
        problem(162),
    ])

contest_16377 = () ->
    return contest("3В: Дополнительные задачи на разные темы - 3", [
        problem(413),
        problem(1764),
        problem(1),
        problem(608),
        problem(111521),
    ])

contest_16376 = () ->
    return contest("3В: Дополнительные задачи на разные темы - 2", [
        problem(476),
        problem(1472),
        problem(586),
        problem(182),
        problem(111493),
        problem(1992),
    ])

contest_16378 = () ->
    return contest("3В: Дополнительные задачи на разные темы - 4", [
        problem(245),
        problem(111634),
        problem(490),
        problem(468),
        problem(470),
    ])

export default level_3C = () ->
    return level("3В", [
        label("<p>Чтобы перейти на следующий уровень, надо решить <b>хотя бы половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        contest_16375(),
        contest_16376(),
        contest_16377(),
        contest_16378(),
    ])