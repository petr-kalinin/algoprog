import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default advanced_numbers = () ->
    return {
        topic: topic(
            ruen("Продвинутая теория чисел, китайская теорема об остатках", "Advanced number theory, Chinese remainder theorem"),
            ruen("Задачи на теорию чисел", "Problems on number theory"),
        [label(ruen(
             "<p>См. теорию на e-maxx: <br>\n<a href=\"https://e-maxx.ru/algo/extended_euclid_algorithm\">расширенный алгоритм Евклида</a>, <br>\n<a href=\"https://e-maxx.ru/algo/reverse_element\">обратный по простому модулю</a>, <br>\n<a href=\"https://e-maxx.ru/algo/diofant_2_equation\">линейные диофантовы уравнения</a>, <br>\n<a href=\"https://e-maxx.ru/algo/diofant_1_equation\">линейное уравнение по модулю</a><br>\n<a href=\"https://e-maxx.ru/algo/chinese_theorem\">китайская теорема об остатках</a>.</p>",
             "<p>See the theory on e-maxx: <br>\n<a href=\"https://e-maxx.ru/algo/extended_euclid_algorithm\">advanced Euclid algorithm</a>, <br>\n<a href=\"https://e-maxx.ru/algo/reverse_element\">inverse by simple modulus</a>, <br>\n<a href=\"https://e-maxx.ru/algo/diofant_2_equation\">linear diophantine equations</a>, <br>\n<a href=\"https://e-maxx.ru/algo/diofant_1_equation\">linear equation modulo</a><br>\n<a href=\"https://e-maxx.ru/algo/chinese_theorem\">the Chinese remainder theorem</a>.</p>")),
            problem(3299),
            problem(4188),
            problem(3880),
            problem(1133),
        ], "advanced_numbers"),
        advancedProblems: [
            problem(3887),
            problem(111597),
        ]
    }