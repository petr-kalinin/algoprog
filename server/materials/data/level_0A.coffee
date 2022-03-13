import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

contest_42757 = () ->
    return contest("0A: Ввод-вывод", [
        problem(2937),
        problem(2938),
        problem(2939),
        problem(2941),
        problem(2942),
        problem(2943),
        problem(2944),
        problem(2945),
        problem(2947),
        problem(2949),
        problem(2951),
        problem(2952),
    ])

contest_42759 = () ->
    return contest("0A: Ввод-вывод. Сложный уровень.", [
        problem(2948),
        problem(2950),
        problem(2953),
        problem(2954),
        problem(2956),
        problem(2957),
    ])

contest_42766 = () ->
    return contest("0A: Условный оператор if. Сложный уровень", [
        problem(258),
        problem(259),
        problem(264),
        problem(295),
        problem(302),
        problem(303),
        problem(1448),
        problem(304),
        problem(305),
        problem(1445),
        problem(1459),
    ])

contest_42765 = () ->
    return contest("0A: Условный оператор if", [
        problem(292),
        problem(2959),
        problem(253),
        problem(294),
        problem(254),
        problem(255),
        problem(256),
        problem(298),
        problem(257),
        problem(296),
        problem(266),
    ])

export default level_0A = () ->
    return level("0A", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/TyVexzAdgIQ\">Теоретический материал</a> </div></div></div></div></div></div>"),
        contest_42757(),
        contest_42759(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">При решении задач данного раздела нельзя пользоваться условной инструкцией if и циклами.</div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/L-Sqi6owiI0\">Теоретический материал</a></div></div></div></div></div></div>"),
        contest_42765(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/CLqlOMeRjNk\">Теоретический материал</a></div></div></div></div></div></div>"),
        contest_42766(),
    ])