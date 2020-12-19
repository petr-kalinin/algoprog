import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default geometry_middle = () ->
    return {
        topic: topic("Геометрия средней сложности", "Задачи на среднюю геометрию", [
            label("<p>Материал должен быть ближе к концу соответствующей лекции <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">в ЛКШ.2013.B'</a><br>\nТакже можете смотреть нужные по каждой задаче разделы на e-maxx.</p>"),
            problem(289),
            problem(288),
            problem(1877),
            problem(2979),
            problem(3858),
        ], "geometry_middle"),
        advancedProblems: [
            problem(488),
            problem(493),
            problem(2866),
            problem(1109),
            problem(455),
            problem(397),
        ]
    }