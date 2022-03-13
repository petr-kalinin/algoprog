import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_47960 = () ->
    return contest("0C: Одномерные массивы", [
        problem(63),
        problem(64),
        problem(65),
        problem(66),
        problem(67),
        problem(68),
        problem(70),
        problem(72),
    ])

contest_47961 = () ->
    return contest("0C: Одномерные массивы. Сложный уровень", [
        problem(69),
        problem(71),
        problem(73),
        problem(1456),
        problem(1457),
        problem(1460),
        problem(1461),
    ])

contest_51001 = () ->
    return contest("0C: Двумерные массивы", [
        problem(354),
        problem(355),
        problem(356),
        problem(357),
        problem(358),
        problem(359),
        problem(360),
        problem(361),
        problem(362),
        problem(363),
        problem(1458),
    ])

contest_51002 = () ->
    return contest("0C: Двумерные массивы. Сложный уровень", [
        problem(1444),
        problem(364),
        problem(365),
        problem(1464),
    ])

export default level_0C = () ->
    return level("0C", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/oe-6sRWzzBs\">Теоретический материал</a></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\">Теория про вектора -&nbsp;<a href=\"https://youtu.be/C8UD47ox4N4\" target=\"_blank\">https://youtu.be/C8UD47ox4N4</a><br></p></div></div></div></div></div></div>"),
        contest_47960(),
        contest_47961(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        contest_51001(),
        contest_51002(),
    ])