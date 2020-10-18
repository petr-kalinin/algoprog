import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default bfs_01 = () ->
    return {
        topic: topic("Поиск в ширину в 1-k и 0-k графах", "Задачи на поиск в ширину в 1-k и 0-k графах", [
            label("<a href=\"https://sis.khashaev.ru/2013/july/b-prime/vw4U9aCQA2o/\">Видеозаписи ЛКШ, 2013, B'</a><br>\n<a href=\"https://sis.khashaev.ru/2008/august/b-prime/ajEpcdbJ-sE/\">Видеозаписи ЛКШ, 2008, B'</a> (см. эту и следующие темы, до \"Повторение: кратчайшие пути в 0-1-графе.\")"),
            problem(3376),
            problem(2003),
        ], "bfs_01")
    }