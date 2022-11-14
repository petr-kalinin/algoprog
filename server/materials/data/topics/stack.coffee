import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default stack = () ->
    return {
        topic: topic(
            ruen("Стек, очередь, дек", "Stack, queue, dequeue"),
            ruen("Задачи на стек, очередь и дек", "Problems on stack, queue and dequeue"),
        [label(ruen(
             "Теории по этим темам тут пока нет, но очень много теории есть в интернете. Вот, например, что я нашел: <a href=\"https://algolist.manual.ru/ds/basic/\">раз</a>, <a href=\"https://brestprog.by/topics/datastructures/\">два</a>.",
             "Some theory:<br/>
             <a href='https://people.orie.cornell.edu/snp32/orie_6125/data-structures/stack-queue-deque.html'>one</a> (do not bother with doubling the array yet, use fixed-size arrays),<br/>
             <a href='https://www.happycoders.eu/algorithms/stack-data-structure/'>two part 1</a>, <a href='https://www.happycoders.eu/algorithms/queue-data-structure/'>two part 2</a>, <a href='https://www.happycoders.eu/algorithms/deque-data-structure/'>two part 3</a> (in all these three parts, read mainly the into section and Implement using an Array section).")),
            problem(54),
            problem(58),
            problem(61),
            problem(50),
        ], "stack"),
        advancedProblems: [
            problem(51),
            problem(112736),
            problem(52),
            problem(111648),
        ]
    }