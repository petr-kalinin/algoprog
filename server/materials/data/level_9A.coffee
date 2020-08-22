import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import topic from "../lib/topic"

topic_module_35700_0 = () ->
    return topic("LCA", null, [
        label("<p><a href=\"https://aleks5d.github.io/blog_LCA_1.html\">Теория по LCA от Алексея Упирвицкого</a></p>\n<p>См. еще <a href=\"https://e-maxx.ru/algo/\">теорию на e-maxx (там несколько разделов)</a>.</p>"),
        label("Задач тут пока нет :( Поищите на CF"),
    ])

topic_35678 = () ->
    return topic("Дерево Фенвика", "9А: Задачи на дерево Фенвика", [
        label("<p>См. <a href=\"https://e-maxx.ru/algo/fenwick_tree\">теорию на e-maxx</a>.</p>"),
        label("В контесте ниже задачи можно решить и деревом отрезков (и часть из них уже была в соответствующем контесте), но решите теперь их деревом Фенвика."),
        problem(3317),
        problem(3568),
    ])

topic_35193 = () ->
    return topic("Простые потоки", "9А: Задачи на простые потоки", [
        label("<p>См. теорию на вики ИТМО: <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=%D0%9E%D0%BF%D1%80%D0%B5%D0%B4%D0%B5%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5_%D1%81%D0%B5%D1%82%D0%B8,_%D0%BF%D0%BE%D1%82%D0%BE%D0%BA%D0%B0\">1</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%A4%D0%BE%D1%80%D0%B4%D0%B0-%D0%A4%D0%B0%D0%BB%D0%BA%D0%B5%D1%80%D1%81%D0%BE%D0%BD%D0%B0,_%D1%80%D0%B5%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F_%D1%81_%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E_%D0%BF%D0%BE%D0%B8%D1%81%D0%BA%D0%B0_%D0%B2_%D0%B3%D0%BB%D1%83%D0%B1%D0%B8%D0%BD%D1%83\">2</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%AD%D0%B4%D0%BC%D0%BE%D0%BD%D0%B4%D1%81%D0%B0-%D0%9A%D0%B0%D1%80%D0%BF%D0%B0\">3</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B7,_%D0%BB%D0%B5%D0%BC%D0%BC%D0%B0_%D0%BE_%D0%BF%D0%BE%D1%82%D0%BE%D0%BA%D0%B5_%D1%87%D0%B5%D1%80%D0%B5%D0%B7_%D1%80%D0%B0%D0%B7%D1%80%D0%B5%D0%B7\">4</a>.\n</p>\n<p>Если в вики ИТМО слишком теоретизированно, посмотрите где-нибудь еще. Продвинутые алгоритмы потока (проталкивание предпотока, Диница) пока не нужны.</p>"),
        problem(2783),
        problem(1574),
        problem(111772),
        problem(2917),
        problem(2785),
    ])

export default level_9A = () ->
    return level("9А", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_35193(),
        topic_35678(),
        topic_module_35700_0(),
    ])