import contest from "../../lib/contest"
import label from "../../lib/label"
import labelLink from "../../lib/labelLink"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default pythonAdditional = () ->
    return {
        topic: topic(
            ruen("*Дополнительные замечания по питону", "*Additional notes on python"),
            null,
        [labelLink(ruen("https://notes.algoprog.ru/python_basics/6_functions.html", "https://notes.algoprog.ru/en/python_basics/6_functions.html"), ruen("Функции", "Functions"))
            labelLink(ruen("https://notes.algoprog.ru/python_basics/7_files.html", "https://notes.algoprog.ru/en/python_basics/7_files.html"), ruen("Работа с файлами", "Working with files"))
            labelLink(ruen("https://notes.algoprog.ru/python_basics/8_addtypes.html", "https://notes.algoprog.ru/en/python_basics/8_addtypes.html"), ruen("Еще разные полезные типы данных", "Some additional useful data types"))
        ], "python_additional"),
        count: false
    }