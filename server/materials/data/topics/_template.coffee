import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default backtrack = () ->
    return {
        topic: topic(
            ruen("*Рекурсивный перебор", "*Recursive iteration"),
            ruen("*Задачи на рекурсивный перебор", "*Recursive search tasks"),
        [label(ruen(
             "Эта тема является довольно сложной, поэтому, если вы в ней не разберетесь, то можете пропустить, и вернуться к ней на уровне 5А. Тем не менее, рекурсивный перебор является очень полезной техникой, поэтому постарайтесь ее освоить уже сейчас.",
             "This topic is quite complex, so if you don't understand it, you can skip it and return to it at level 5A. However, recursive brute force is a very useful technique, so try to master it now.")),
            label(ruen(
                "<a href=\"https://notes.algoprog.ru/backtrack/index.html\">Теория по рекурсивному перебору</a><br>\nСм. также <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Рекурсивный перебор»",
                "<a href=\"https://notes.algoprog.ru/backtrack/index.html\">Theory of recursive iteration</a><br>\nSee also video <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">recordings of lectures of the Parallel C'</a> LCS, section \"Recursive search\"")),
            link("https://informatics.msk.ru/mod/resource/view.php?id=16016", "Красивая картинка рекурсивного дерева"),
            problem(80),
            problem(84),
            problem(85),
            problem(89),
            problem(90),
            problem(91),
            problem(485),
            problem(1182),
        ]),
        advancedTopics: [
            contest("2В: *Продвинутые задачи на рекурсивный перебор", [
                problem(157),
                problem(1680),
                problem(2776),
                problem(3879),
                problem(3096),
                problem(158),
                problem(159),
            ]),
            module16828()       
        ]
    }