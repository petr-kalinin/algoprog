import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_42668 = () ->
    return contest("1А: Перебор", [
        problem(82),
        problem(81),
        problem(84),
        problem(155),
        problem(88),
        problem(85),
        problem(3096),
        problem(3095),
    ])

contest_68662 = () ->
    return contest("1A: Рекурсия, перебор - сложные задачи", [
        problem(1470),
        problem(200),
        problem(778),
        problem(194),
        problem(187),
        problem(89),
        problem(90),
    ])

contest_53356 = () ->
    return contest("1A: Рекурсия", [
        problem(113653),
        problem(113654),
        problem(113655),
        problem(153),
        problem(1414),
        problem(156),
    ])

export default level_1A = () ->
    return level("1A", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://drive.google.com/file/d/17mxR4D5thepSALQZR62VBU96TsYCAEYA/view?usp=sharing\">Теоретический материал</a></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\">Теоретический материал -&nbsp;<a href=\"https://youtu.be/If7w3kuxvc4\" target=\"_blank\">https://youtu.be/If7w3kuxvc4</a></p></div></div></div></div></div></div>"),
        contest_53356(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://drive.google.com/file/d/1dZ5IJTEMOsGBSJcWQXKN-zSCux6-Nfrh/view?usp=sharing\">Теоретический материал. Автор Петр Калинин</a></div></div></div></div></div></div>"),
        contest_42668(),
        contest_68662(),
    ])