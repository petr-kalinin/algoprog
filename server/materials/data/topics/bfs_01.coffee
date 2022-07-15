import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default bfs_01 = () ->
    return {
        topic: topic(
            ruen("Поиск в ширину в 1-k и 0-k графах", "Breadth-first search in 1-k and 0-k graphs"),
            ruen("Задачи на поиск в ширину в 1-k и 0-k графах", "Problems on breadth-first search in 1-k and 0-k graphs"),
        [label(ruen(
             "<a href=\"https://sis.khashaev.ru/2013/july/b-prime/vw4U9aCQA2o/\">Видеозаписи ЛКШ, 2013, B'</a><br>\n<a href=\"https://sis.khashaev.ru/2008/august/b-prime/ajEpcdbJ-sE/\">Видеозаписи ЛКШ, 2008, B'</a> (см. эту и следующие темы, до \"Повторение: кратчайшие пути в 0-1-графе.\")",
             "<a href=\"https://sis.khashaev.ru/2013/july/b-prime/vw4U9aCQA2o/\">SIS videos, 2013, B'</a><br>\n<a href=\"https://sis.khashaev.ru/2008/august/b-prime/ajEpcdbJ-sE/\">SIS videos, 2008, B'</a> (see this and the following topics, up to \"Repetition: Shortest paths in a 0-1 graph.\")")),
            problem(3376),
            problem(2003),
        ], "bfs_01")
    }