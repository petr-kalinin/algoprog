import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_26196 = () ->
    return topic("Паросочетания и связанные темы", "8А: Задачи на паросочетания", [
        label("<p><a href=\"http://e-maxx.ru/algo/kuhn_matching\">Теория на e-maxx</a><br>\nДополнительный (но важный) материал на вики ИТМО: <a href=\"http://neerc.ifmo.ru/wiki/index.php?title=Связь_максимального_паросочетания_и_минимального_вершинного_покрытия_в_двудольных_графах\">раз</a>, <a href=\"http://neerc.ifmo.ru/wiki/index.php?title=Связь_вершинного_покрытия_и_независимого_множества\">два</a>.<br>\nНа тему связи паросочетания, независимого множества и вершинного покрытия можете еще поискать в интернете, если в конспекте ИТМО непонятно.</p>"),
        problem(1683),
        problem(588),
        problem(4204),
        problem(111663),
    ])

topic_26194 = () ->
    return topic("Системы непересекающихся множеств и минимальный остов", "8А: Задачи на СНМ и минимальный остов", [
        label("<p>См. <a href=\"http://sis.khashaev.ru/2013/july/a-prime/\">соответствующую лекцию параллели A'</a><br>\nСм. лекции \"Система непересекающихся множеств (СНМ)\" и \"Остовные деревья\" из <a href=\"http://sis.khashaev.ru/2008/august/b-prime/\">ЛКШ.2008.B'</a></p>\n<p>Теория на e-maxx:<br>\n- <a href=\"http://e-maxx.ru/algo/dsu\">Система непересекающихся множеств</a><br>\n- <a href=\"http://e-maxx.ru/algo/mst_kruskal\">Алгоритм Краскала</a><br>\n- <a href=\"http://e-maxx.ru/algo/mst_kruskal_with_dsu\">Как подружить Краскала и СНМ</a><br>\n- <a href=\"http://e-maxx.ru/algo/mst_prim\">Алгоритм Прима</a>\n</p>"),
        problem(3558),
        problem(1362),
        problem(1376),
        problem(185),
    ])

topic_26198 = () ->
    return topic("Функция Гранди", "8А: Задачи на функцию Гранди", [
        label("<p><a href=\"http://e-maxx.ru/algo/sprague_grundy\">Теория на e-maxx</a><br>\n<a href=\"https://habrahabr.ru/post/124856/\">Теория на хабре</a><br>\n<a>Можете еще в интернете поискать</a></p>"),
        problem(369),
        problem(905),
    ])

export default level_8A = () ->
    return level("8А", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_26194(),
        topic_26196(),
        topic_26198(),
    ])