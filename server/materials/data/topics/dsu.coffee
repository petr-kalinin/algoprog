import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default dsu = () ->
    return {
        topic: topic("Системы непересекающихся множеств и минимальный остов", "Задачи на СНМ и минимальный остов", [
            label("<p>См. <a href=\"https://sis.khashaev.ru/2013/july/a-prime/\">соответствующую лекцию параллели A'</a><br>\nСм. лекции \"Система непересекающихся множеств (СНМ)\" и \"Остовные деревья\" из <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">ЛКШ.2008.B'</a></p>\n<p>Теория на e-maxx:<br>\n- <a href=\"https://e-maxx.ru/algo/dsu\">Система непересекающихся множеств</a><br>\n- <a href=\"https://e-maxx.ru/algo/mst_kruskal\">Алгоритм Краскала</a><br>\n- <a href=\"https://e-maxx.ru/algo/mst_kruskal_with_dsu\">Как подружить Краскала и СНМ</a><br>\n- <a href=\"https://e-maxx.ru/algo/mst_prim\">Алгоритм Прима</a>\n</p>"),
            problem(3558),
            problem(1362),
            problem(1376),
            problem(185),
        ], "dsu"),
        advancedProblems: [
            problem(2786),
            problem(111749),
        ]
    }