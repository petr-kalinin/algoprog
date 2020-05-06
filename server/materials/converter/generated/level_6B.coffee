import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_19484 = () ->
    return topic("Простая геометрия", "6Б: Задачи на простую геометрию", [
        label("<p>См. <a href=\"http://sis.khashaev.ru/2013/july/b-prime/\">видеозаписи лекций ЛКШ.2013.B'</a>, раздел \"Вычислительная геометрия\".<br>\nСм. <a href=\"http://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ.2008.B'</a>, раздел \"Вычислительная геометрия\".</p>"),
        problem(269),
        problem(275),
        problem(436),
        problem(447),
        problem(448),
        problem(1353),
        problem(279),
        problem(280),
        problem(433),
    ])

topic_19482 = () ->
    return topic("Жадные алгоритмы", "6Б: Задачи на жадность", [
        label("<p><a href=\"http://www.williamspublishing.com/PDF/5-8459-0857-4/part.pdf\">Довольно продвинутая теория</a> (про коды Хаффмана можете не читать, можете прочитать \"для сведения\"). Еще вспомните теорию с уровня 2Б, и можете еще погуглить.</p>\n<p>Задачи ниже какие-то скучные, но других на этом сайте я не нашел.</p>"),
        problem(3356),
        problem(3380),
        problem(3589),
    ])

export default level_6B = () ->
    return level("6Б", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_19482(),
        topic_19484(),
    ])