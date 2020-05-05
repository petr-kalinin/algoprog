import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic16684 = () ->
    return topic("Алгоритм Дейкстры", "4Б: Задачи на алгоритм Дейкстры", [
        label("<h4>Алгоритм Дейкстры</h4>"),
        label("<a href=\"http://sis.khashaev.ru/2008/august/b-prime/\">Лекция про алгоритм Дейкстры в ЛКШ.2008.B'</a>, см. раздел «Алгоритм Дейкстры»<br>\n<a href=\"http://e-maxx.ru/algo/dijkstra\">Теория по алгоритму Дейкстры на e-maxx</a><br>\n<a href=\"http://sis.khashaev.ru/2013/july/b-prime/\">Лекция про особенностям алгоритма Дейкстры в ЛКШ.2013.B'</a>, см. раздел «Кратчашие пути в графах» (частично; использование кучи вам пока не нужно)<br>"),
        problem(5),
        problem(6),
        problem(7),
        problem(170),
    ])

topic16878 = () ->
    return topic("Сортировка событий", "4Б: Задачи на сортировку событий", [
        label("<h4>Сортировка событий</h4>\nТеории тут пока нет, прослушайте на занятии (попросите меня рассказать)."),
        problem(112542),
        problem(1755),
        problem(3721),
        problem(1338),
        problem(111790),
    ])

topic16788 = () ->
    return topic("Длинная арифметика", "4Б: Задачи на длинную арифметику", [
        label("<h4>Длинная арифметика</h4>"),
        label("Длинная арифметика сейчас не часто требуется в олимпиадных задачах (если ответ на задачу может быть большой, то чаще вас попросят посчитать остаток по некоторому модулю), но тем не менее иметь представление об алгоритмах и уметь их писать надо.<br>\n<a href=\"http://informatics.mccme.ru/file.php/17/dlinnaya-arifmetika.doc\">Теория по длинной арифметике (В. Гольдштейн)</a><br>\n<a href=\"https://www.youtube.com/watch?v=n-sT7BENNxA\">Видеозапись лекции из какой-то ЛКШ</a> (подозреваю, что ЛКШ.2008.C)<br>"),
        problem(132),
        problem(134),
        problem(136),
        problem(139),
    ])

topic16784 = () ->
    return topic("Сортировка подсчетом", "4Б: Задачи на сортировку подсчетом", [
        label("<h4>Сортировка подсчетом</h4>\nСм. <a href=\"http://sis.khashaev.ru/2013/august/c-prime/Prz7x1bkW5Y/\">видеозаписи лекций ЛКШ параллели C'</a><br>\nСм. видеозаписи лекций ЛКШ параллели B' (старой): <a href=\"http://sis.khashaev.ru/2008/august/b-prime/kVcmMxhr-CI/\">раз</a> и <a href=\"http://sis.khashaev.ru/2008/august/b-prime/mkdwnjYkg-g/\">два</a><br>\nСм. <a href=\"http://sis.khashaev.ru/2013/july/b-prime/X27QTFl70lY/\">видеозаписи лекций ЛКШ параллели B' (новой)</a>"),
        label("Набор задач ниже, к сожалению, не очень представителен, но на этом сайте нет больше интересных задач на сортировку подсчетом."),
        problem(111759),
        problem(49),
        problem(1027),
    ])

export default level_4B = () ->
    return level("4Б", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic16684(),
        topic16784(),
        topic16788(),
        topic16878(),
    ])