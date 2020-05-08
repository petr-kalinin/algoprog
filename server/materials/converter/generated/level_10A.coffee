import label from "../../lib/label"
import level from "../../lib/level"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

topic_39722 = () ->
    return topic("Продвинутая теория чисел, китайская теорема об остатках", "10А: Задачи на теорию чисел", [
        label("<p>См. теорию на e-maxx: <br>\n<a href=\"http://e-maxx.ru/algo/extended_euclid_algorithm\">расширенный алгоритм Евклида</a>, <br>\n<a href=\"http://e-maxx.ru/algo/reverse_element\">обратный по простому модулю</a>, <br>\n<a href=\"http://e-maxx.ru/algo/diofant_2_equation\">линейные диофантовы уравнения</a>, <br>\n<a href=\"http://e-maxx.ru/algo/diofant_1_equation\">линейное уравнение по модулю</a><br>\n<a href=\"http://e-maxx.ru/algo/chinese_theorem\">китайская теорема об остатках</a>.</p>"),
        problem(3299),
        problem(4188),
        problem(3880),
        problem(1133),
    ])

topic_39767 = () ->
    return topic("Суффиксные структуры данных", "10А: Задачи на суффиксные структуры", [
        label("<p>См. теорию на e-maxx: <br>\n<a href=\"http://e-maxx.ru/algo/suffix_array\">суффиксный массив</a>, <br>\n<a href=\"http://e-maxx.ru/algo/suffix_automata\">суффиксный автомат</a>, <br>\n<a href=\"http://e-maxx.ru/algo/ukkonen\">суффиксное дерево</a>.</p>"),
        problem(111789),
    ])

topic_39772 = () ->
    return topic("Сложная геометрия", "10А: Задачи на сложную геометрию", [
        problem(34),
        problem(923),
        problem(1109),
        problem(111780),
        problem(1360),
        problem(1128),
        problem(3209),
    ])

export default level_10A = () ->
    return level("10А", [
        label("<p>Чтобы перейти на следующий уровень, надо решить все задачи.</p>"),
        topic_39722(),
        topic_39767(),
        topic_39772(),
    ])