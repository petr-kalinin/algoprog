import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default geometry_middle = () ->
    return {
        topic: topic(
            ruen("Геометрия средней сложности", "Problems of medium difficulty on geometry"),
            ruen("Задачи на среднюю геометрию", "Problems of medium difficulty on geometry"),
        [label(ruen(
             "<p>Материал должен быть ближе к концу соответствующей лекции <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">в ЛКШ.2013.B'</a><br>\nТакже можете смотреть нужные по каждой задаче разделы на e-maxx.</p>",
             "<p>The material should be closer to the end of the corresponding lecture <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">in SIS.2013.B'</a><br>\nYou can also view the sections needed for each task on e-maxx.</p>")),
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