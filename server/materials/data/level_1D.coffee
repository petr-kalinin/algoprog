import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

title = (num) ->
    (label) ->
        if label == "" then "Дополнительные задачи на разные темы — #{num}"
        else if label == "!en" then "Additional miscellaneous problems — #{num}"
        else throw "unknown label #{label}"

contest_15993 = () ->
    return contest(title(1), [
        problem(3469),
        problem(3466),
        problem(3477),
        problem(3472),
        problem(2954),
        problem(1370),
        problem({testSystem: "codeforces", contest: "381", problem: "B"}),
    ])

contest_15994 = () ->
    return contest(title(2), [
        problem(111499),
        problem(3888),
        problem(3893),
        problem(507),
        problem(511),
        problem(482),
        problem(483),
    ])

contest_15996 = () ->
    return contest(title(3), [
        problem(1421),
        problem(3745),
        problem(1406),
        problem(592),
        problem(1209),
        problem(855),
        problem(1435),
        problem(993),
        problem(111580),
        problem(2958),
    ])

export default level_1D = () ->
    message = (lbl) ->
        if lbl == "" then "Чтобы перейти на следующий уровень, надо решить <b>минимум треть задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца."
        else if lbl == "!en" then "To advance to next level, you need to solve <b>at least one third of the problems</b>. When you solve them, I recommend that you move to the next level, so as not to delay the study of new theory. Return to the remaining tasks of this level later from time to time and try to gradually solve almost all of them."
        else throw "Unknown label #{lbl}"
    pMessage = (lbl) -> "<p>#{message(lbl)}</p>"
    name = (lbl) -> 
        if lbl == "" then "1Г"
        else if lbl == "!en" then "1D"
    return level(name, [
        label(pMessage),
        contest_15993(),
        contest_15994(),
        contest_15996(),
    ])