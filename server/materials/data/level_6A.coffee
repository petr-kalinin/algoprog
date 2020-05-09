import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import topic from "../lib/topic"

topic_19477 = () ->
    return topic("Простые игры на графах", "6А: Простые игры на графах", [
        label("<a href=\"http://e-maxx.ru/algo/games_on_graphs\">Некоторая теория на e-maxx</a>"),
        problem(202),
        problem(366),
        problem(3344),
        problem(371),
    ])

topic_19474 = () ->
    return topic("Алгоритмы Флойда и Форда-Беллмана", "6А: Задачи на алгоритмы Флойда и Форда-Беллмана", [
        label("<b>Алгоритм Флойда</b><br>\n<a href=\"http://sis.khashaev.ru/2013/july/b-prime/C-y1_dlKRdY/\">Видеозаписи ЛКШ, 2013, B'</a><br>\n<a href=\"http://sis.khashaev.ru/2008/august/b-prime/kXYH8tIsOEQ/\">Видеозаписи ЛКШ, 2008, B'</a><br>\n<b>Алгоритм Форла-Беллмана</b><br>\n<a href=\"http://sis.khashaev.ru/2013/july/b-prime/1fCe1I5ZV64/\">Видеозаписи ЛКШ, 2013, B'</a><br>\n<a href=\"http://sis.khashaev.ru/2008/august/b-prime/YvdwkhFS2_U/\">Видеозаписи ЛКШ, 2008, B'</a>"),
        problem(171),
        problem(97),
        problem(172),
        problem(1332),
        problem(3342),
        problem(178),
        problem(179),
        problem(524),
    ])

topic_16558 = () ->
    return topic("Поиск в ширину в 1-k и 0-k графах", "6А: Задачи на поиск в ширину в 1-k и 0-k графах", [
        label("<a href=\"http://sis.khashaev.ru/2013/july/b-prime/vw4U9aCQA2o/\">Видеозаписи ЛКШ, 2013, B'</a><br>\n<a href=\"http://sis.khashaev.ru/2008/august/b-prime/ajEpcdbJ-sE/\">Видеозаписи ЛКШ, 2008, B'</a> (см. эту и следующие темы, до \"Повторение: кратчайшие пути в 0-1-графе.\")"),
        problem(3376),
        problem(2003),
    ])

export default level_6A = () ->
    return level("6А", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_19474(),
        topic_19477(),
        topic_16558(),
    ])