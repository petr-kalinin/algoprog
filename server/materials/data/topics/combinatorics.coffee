import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default combinatorics = () ->
    return {
        topic: topic("Комбинаторика", "Задачи на комбинаторику ", [
            label("""Для ряда комбинаторных объектов (последовательностей из нулей и единиц, перестановок и т.д.) 
                есть интересные алгоритмы типа генерации следующего объекта по текущему и т.п. 
                Эти алгоритмы имеют не очень большую применимость (собственно, поэтому тема и убрана так высоко), 
                в большинстве случаев проще написать алгоритм на базе рекурсивного перебора или динамики,
                но полезно знать и конкретные специальные алгоритмы."""),
            problem({testSystem: "ejudge", contest: "2001", problem: "3"}),
            problem(194),
            problem(190),
            problem(192),
        ], "combinatorics"),
        advancedProblems: [
            problem(2517),
            problem(86)
        ]
    }