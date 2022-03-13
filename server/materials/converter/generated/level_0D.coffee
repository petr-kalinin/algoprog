import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_53130 = () ->
    return contest("0D: Строки #2", [
        problem(111),
        problem(112),
        problem(1415),
        problem(1417),
        problem(1421),
        problem(1435),
        problem(1450),
    ])

contest_53129 = () ->
    return contest("0D: Строки #1", [
        problem(102),
        problem(103),
        problem(104),
        problem(105),
        problem(106),
        problem(107),
        problem(108),
        problem(109),
        problem(110),
    ])

contest_53287 = () ->
    return contest("0D: Функции", [
        problem(306),
        problem(307),
        problem(308),
        problem(309),
        problem(252),
        problem(312),
        problem(313),
    ])

export default level_0D = () ->
    return level("0D", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/8Ksqe1oLbg8\">Теоретический материал</a></div></div></div></div></div></div>"),
        contest_53129(),
        contest_53130(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\">Теоретический материал 3.3.13.Функции (на данном этапе читать необходимо только данную главу). Автор Петр Калинин -&nbsp;<a href=\"https://notes.algoprog.ru/cpp/syntax.html#id11\" target=\"_blank\">https://notes.algoprog.ru/cpp/syntax.html#id11</a></p></div></div></div></div></div></div>"),
        contest_53287(),
    ])