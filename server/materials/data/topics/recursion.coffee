import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default recursion = () ->
    return {
        topic: topic("Рекурсия", "Задачи на рекурсию", [
            label("<a href='https://foxford.ru/wiki/informatika/rekursiya-v-python'>Теория на фоксфорде</a>"),
            label("""Имейте в виду, что многие из задач ниже на самом деле проще и правильнее решать не рекурсией, а циклом 
            (в частности, никогда не пишите факториал или числа Фибоначчи рекурсией!). 
            Но понимать, что такое рекурсия, надо, и очень полезно потренироваться на задачах ниже.""")
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
