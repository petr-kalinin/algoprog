import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

contest_70249 = () ->
    return contest("1C: Битовые операции", [
        problem(123),
        problem(122),
        problem(124),
        problem(126),
        problem(128),
        problem(125),
        problem(129),
        problem(121),
        problem(127),
        problem(80),
    ])

contest_63442 = () ->
    return contest("1C: Последовательности и одномерная динамика", [
        problem(201),
        problem(203),
        problem(912),
        problem(913),
        problem(914),
        problem(915),
        problem(2963),
        problem(2968),
        problem(210),
        problem(212),
    ])

contest_70225 = () ->
    return contest("1C: STL", [
        problem(49),
        problem(50),
        problem(51),
        problem(52),
        problem(112984),
        problem(53),
        problem(112536),
        problem(2782),
        problem(111771),
        problem(3492),
    ])

contest_70224 = () ->
    return contest("1C: Стек, очередь, дэк. Реализация ", [
        problem(54),
        problem(55),
        problem(57),
        problem(58),
        problem(60),
        problem(61),
    ])

contest_63443 = () ->
    return contest("1C: Двумерная динамика", [
        problem(206),
        problem(943),
        problem(944),
        problem(945),
        problem(946),
        problem(2966),
    ])

contest_63444 = () ->
    return contest("1C: НВП, НОП, Рюкзак", [
        problem(204),
        problem(1790),
        problem(205),
        problem(1792),
        problem(3087),
        problem(3089),
        problem(1120),
        problem(3090),
    ])

export default level_1C = () ->
    return level("1C", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\"></p><br><p></p></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\"></p><br><p></p></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\">Теоретический материал Битовые операции:&nbsp;<a href=\"https://youtu.be/dh1Z7cfaTwE\" target=\"_blank\">https://youtu.be/dh1Z7cfaTwE</a></p></div></div></div></div></div></div>"),
        contest_70249(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\"></p><br><p></p></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">Теоретический материал STL:&nbsp;<a href=\"https://youtu.be/uWtTFdRFR8g\" target=\"_blank\">https://youtu.be/uWtTFdRFR8g</a></div></div></div></div></div></div>"),
        contest_70224(),
        contest_70225(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\"></p><p></p></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">Текстовый материал динамическое программирование:&nbsp;<a href=\"https://notes.algoprog.ru/dynprog/index.html\">https://notes.algoprog.ru/dynprog/index.html</a></div></div></div></div></div></div>"),
        contest_63442(),
        contest_63443(),
        contest_63444(),
    ])