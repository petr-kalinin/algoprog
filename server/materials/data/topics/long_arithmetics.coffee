import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default long_arithmetics = () ->
    return {
        topic: topic("Длинная арифметика", "Задачи на длинную арифметику", [
            label("Длинная арифметика сейчас не часто требуется в олимпиадных задачах (если ответ на задачу может быть большой, то чаще вас попросят посчитать остаток по некоторому модулю), но тем не менее иметь представление об алгоритмах и уметь их писать надо.<br>\n<a href=\"https://informatics.mccme.ru/file.php/17/dlinnaya-arifmetika.doc\">Теория по длинной арифметике (В. Гольдштейн)</a><br>\n<a href=\"https://www.youtube.com/watch?v=n-sT7BENNxA\">Видеозапись лекции из какой-то ЛКШ</a> (подозреваю, что ЛКШ.2008.C)<br>"),
            problem(132),
            problem(134),
            problem(136),
            problem(139),
        ], "long_arithmetics"),
        advancedProblems: [
            problem(207),
            problem(145),
            problem(648),
            problem(143),
            problem(1210),
        ]
    }