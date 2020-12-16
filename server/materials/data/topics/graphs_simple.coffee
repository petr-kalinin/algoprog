import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default graph_simple = () ->
    return {
        topic: topic("Проcтые графы", "Задачи на простые графы", [
            label("Теории тут пока нет. Можете прочитать основные вещи <a href=\"https://ru.wikipedia.org/wiki/%D0%93%D1%80%D0%B0%D1%84_(%D0%BC%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B0)\">в википедии</a> (хотя там много лишней терминологии), или <a href=\"https://pythontutor.ru/lessons/graphs/\">здесь</a> (там реализация на питоне, но, я думаю, вы догадаетесь, как это сделать на паскале), или <a href=\"https://school29.smoladmin.ru/arbuzov/vvedenie.html\">здесь</a> (тут несколько страниц). Вам пока надо только понимать, что такое граф, знать ряд определений, и уметь хранить графы в программе. Из способов хранения графа вам пока будет достаточно матрицы смежности, про остальные можете прочитать для сведения. Обходы графа вам пока не нужны (до следующей темы)."),
            problem(176),
            problem(177),
            problem(174),
            problem(175),
            problem(474),
            problem(479),
        ], "graphs_simple"),
        advancedProblems: [        
            problem(476),
            problem(1992),
            problem(468),
            problem(470),
        ]
    }