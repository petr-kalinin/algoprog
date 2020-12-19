import contest from "../../lib/contest"
import label from "../../lib/label"
import labelLink from "../../lib/labelLink"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default pythonAdditional = () ->
    return {
        topic: topic("*Дополнительные замечания по питону", null, [
            labelLink("https://notes.algoprog.ru/python_basics/6_functions.html", "Функции")
            labelLink("https://notes.algoprog.ru/python_basics/7_files.html", "Работа с файлами")
            labelLink("https://notes.algoprog.ru/python_basics/8_addtypes.html", "Еще разные полезные типы данных")
        ], "python_additional"),
        count: false
    }