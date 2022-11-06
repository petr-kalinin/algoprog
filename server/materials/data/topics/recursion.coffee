import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default recursion = () ->
    return {
        topic: topic(
            ruen("Рекурсия", "Recursion"),
            ruen("Задачи на рекурсию", "Problems on recursion"),
        [label(ruen(
             "<a href='https://foxford.ru/wiki/informatika/rekursiya-v-python'>Теория на фоксфорде</a>",
             "<a href=\"https://www.geeksforgeeks.org/introduction-to-recursion-data-structure-and-algorithm-tutorials/\">Theory on GeeksForGeeks</a>")),
            label(ruen("""Имейте в виду, что многие из задач ниже на самом деле проще и правильнее решать не рекурсией, а циклом 
            (в частности, никогда не пишите факториал или числа Фибоначчи рекурсией!). 
            Но понимать, что такое рекурсия, надо, и очень полезно потренироваться на задачах ниже.""",
            """Keep in mind that many of the tasks below are actually easier and more correct to solve not by recursion, but by a loop
            (in particular, never write factorial or Fibonacci numbers by recursion!).
            But it is necessary to understand what recursion is, and it is very useful to practice on the tasks below."""))
            problem(153),
            problem(154)
            problem(113656),
            problem({testSystem: "ejudge", contest: "2001", problem: "2"}),
            problem(3050)
        ], "recursion"),
        advancedProblems: [
            problem(1414),
            problem(3283),
            problem(3806),
            problem(111589)
        ]
    }
