import contest from "../../lib/contest"
import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"

contest_43031 = () ->
    return contest("0B: Стартовые задачи", [
        problem(113),
        problem(3058),
        problem(3059),
        problem(3060),
        problem(3061),
        problem(3063),
        problem(3075),
        problem(3076),
    ])

contest_43056 = () ->
    return contest("0B: Вычисление сумм и произведений", [
        problem(315),
        problem(351),
        problem(352),
        problem(317),
        problem(319),
        problem(320),
        problem(321),
        problem(353),
        problem(120),
    ])

contest_43033 = () ->
    return contest("0B: Последовательности", [
        problem(3064),
        problem(3065),
        problem(3066),
        problem(3067),
        problem(3068),
        problem(3069),
        problem(3070),
        problem(3072),
        problem(3073),
    ])

contest_68503 = () ->
    return contest("0B: Циклы while, for. Сложные задачи.", [
        problem(3077),
        problem(3078),
        problem(3079),
        problem(3080),
        problem(341),
    ])

contest_43032 = () ->
    return contest("0B: Анализ цифр числа ", [
        problem(114),
        problem(115),
        problem(116),
        problem(117),
        problem(118),
    ])

contest_43058 = () ->
    return contest("0B: Разные задачи на for", [
        problem(333),
        problem(334),
        problem(335),
        problem(340),
        problem(342),
        problem(343),
        problem(345),
        problem(346),
        problem(347),
        problem(348),
        problem(349),
        problem(350),
    ])

export default level_0B = () ->
    return level("0B", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">Сначала просматриваете первый теоретический материал и решаете от него задачи. Далее - анализ цифр числа и уже после него последовательности. </div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/nmBbKQDoY18\">Теоретический материал</a></div></div></div></div></div></div>"),
        contest_43031(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/PCN1xRbeSWo\">Теоретический материал. Анализ цифр числа</a></div></div></div></div></div></div>"),
        contest_43032(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/e4MDDMybLJ8\">Теоретический материал. Последовательности</a></div></div></div></div></div></div>"),
        contest_43033(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><h3>For</h3></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/RvTRPR0N5jw\">Теоретический материал</a></div></div></div></div></div></div>"),
        contest_43056(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/CLqlOMeRjNk\">Теоретический материал</a>\n\n</div></div></div></div></div></div>"),
        contest_43058(),
        contest_68503(),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">Дополнительные необязательные задачи. Для решения задач из данного раздела необходимо скачать книгу Златопольский, Сборник задач по программированию. \nНомера задач: 8.3 8.8 8.13 8.15 8.16 8.17 8.25 8.29 8.30 8.36 8.38 8.49\nВ задачах номерами 8.36 и 8.38 нужно найти все числа, меньшие 100.</div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://youtu.be/iJuva_GxX9s\">Теоретический материал</a></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><a href=\"https://school272.ucoz.ru/TeachersWorks/Kononov/sbornik_zadach_po_programmiroaniyu.pdf\">Златопольский. Сборник задач, 3-е издание</a>\n\n</div></div></div></div></div></div>"),
    ])