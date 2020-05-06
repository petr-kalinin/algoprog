import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_16880 = () ->
    return topic("4В: Дополнительные задачи на разные темы - 1", "4В: Дополнительные задачи на разные темы - 1", [
        problem(207),
        problem(581),
        problem(111540),
        problem(1005),
        problem(145),
        problem(1216),
        problem(648),
    ])

topic_16881 = () ->
    return topic("4В: Дополнительные задачи на разные темы - 2", "4В: Дополнительные задачи на разные темы - 2", [
        problem(143),
        problem(3334),
        problem(1095),
        problem(1106),
        problem(1766),
        problem(2918),
        problem(3878),
    ])

topic_16882 = () ->
    return topic("4В: Дополнительные задачи на разные темы - 3", "4В: Дополнительные задачи на разные темы - 3", [
        problem(1620),
        problem(1210),
        problem(3001),
        problem(1928),
        problem(994),
        problem(40),
        problem(2817),
    ])

export default level_4C = () ->
    return level("4В", [
        label("<p>Чтобы перейти на следующий уровень, необходимо решить <b>хотя бы половину задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>"),
        topic_16880(),
        topic_16881(),
        topic_16882(),
    ])