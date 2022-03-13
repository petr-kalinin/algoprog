import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import link from "../../lib/link"
import problem from "../../lib/problem"

contest_42811 = () ->
    return contest("1B: Квадратичные сортировки ", [
        problem(111158),
        problem(1099),
        problem(734),
        problem(39),
    ])

contest_68501 = () ->
    return contest("1B: Бинарный поиск. Дополнительные не обязательные задачи", [
        problem(414),
        problem(894),
    ])

contest_42815 = () ->
    return contest("1B: Сортировки за логарифм", [
        problem(1425),
        problem(766),
        problem(1418),
        problem(733),
        problem(581),
        problem(641),
    ])

contest_42946 = () ->
    return contest("1B: Бинарный поиск", [
        problem(4),
        problem(2),
        problem(111728),
        problem(742),
    ])

contest_68500 = () ->
    return contest("1B: Бинарный поиск. Сложный уровень.", [
        problem(1),
        problem(490),
        problem(1923),
        problem(1620),
        problem(672),
        problem(111790),
    ])

contest_68663 = () ->
    return contest("1B: Сортировки - сложные задачи", [
        problem(1782),
        problem(755),
        problem(1045),
    ])

export default level_1B = () ->
    return level("1B", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">Видео-лекция по сортировкам:&nbsp;<a href=\"https://youtu.be/WbVcM7ADECA\" target=\"_blank\">https://youtu.be/WbVcM7ADECA</a>&nbsp;<br></div></div></div></div></div></div>"),
        contest_42811(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://drive.google.com/file/d/1LQH4cuS7osy4tffR4Edse7DjCXjvdvRD/view?usp=sharing\">Теоретический материал. Сортировки за логарифм</a></div></div></div></div></div></div>"),
        contest_42815(),
        contest_68663(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">Видео-лекция бинарный поиск:&nbsp;<a href=\"https://youtu.be/T9e_jdm9ulM\" target=\"_blank\">https://youtu.be/T9e_jdm9ulM</a></div></div></div></div></div></div>"),
        link("https://informatics.msk.ru/pluginfile.php/377600/mod_resource/content/0/07_binsearch.pdf", "Теоретический материал"),
        contest_42946(),
        contest_68500(),
        contest_68501(),
    ])