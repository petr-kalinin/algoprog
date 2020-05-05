import label from "../../lib/label"
import level from "../../lib/level"
import level_2A from "./level_2A"
import level_2B from "./level_2B"
import level_2C from "./level_2C"

export default level_2 = () ->
    return level("2", [
        level_2A(),
        label("*Работа с файлами (без контеста)"),
        label("*Функции (без контеста)"),
        label("НОД, алгоритм Евклида"),
        label("*Рекурсивный перебор"),
        label("Квадратичные сортировки"),
        label("Задачи \"на технику\""),
        level_2B(),
        label("Сложность алгоритмов (без контеста)"),
        label("Основы динамического программирования"),
        label("Стек, дек, очередь"),
        label("Простые числа и разложение на множители"),
        label("Простая жадность"),
        level_2C(),
    ])