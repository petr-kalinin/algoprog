import label from "../../lib/label"
import level from "../../lib/level"
import level_1A from "./level_1A"
import level_1B from "./level_1B"
import level_1C from "./level_1C"
import level_1D from "./level_1D"

export default level_1 = () ->
    return level("1", [
        level_1A(),
        label("Арифметические операции"),
        label("Условный оператор"),
        label("Как отлаживать программы"),
        label("Циклы"),
        level_1B(),
        label("Массивы"),
        label("Символы и строки"),
        label("Вещественные числа"),
        level_1C(),
        label("Вещественные числа"),
        label("Основы тестирования задач (без контеста)"),
        label("Задачи"),
        level_1D(),
    ])