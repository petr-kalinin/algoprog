import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default combinatorics = () ->
    return {
        topic: topic(
            ruen("Комбинаторика", "Combinatorics"),
            ruen("Задачи на комбинаторику ", "Problems on combinatorics "),
        [label(ruen("""Для ряда комбинаторных объектов (последовательностей из нулей и единиц, перестановок и т.д.) 
                есть интересные алгоритмы типа генерации следующего объекта по текущему и т.п. 
                Эти алгоритмы имеют не очень большую применимость (собственно, поэтому тема и убрана так высоко), 
                в большинстве случаев проще написать алгоритм на базе рекурсивного перебора или динамики,
                но полезно знать и конкретные специальные алгоритмы.""",
                """For a number of combinatorial objects (sequences of zeros and ones, permutations, etc.), 
                there are interesting algorithms such as generating the next object from the current one, etc.
                These algorithms are not very applicable (in fact, that's why the topic is on so high a level on algoprog),
                in most cases it's easier to write an algorithm based on recursive iteration or dynamics,
                but it is also useful to know specific special algorithms.""")),
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