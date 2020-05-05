import label from "../../lib/label"
import level from "../../lib/level"
import level_4A from "./level_4A"
import level_4B from "./level_4B"
import level_4C from "./level_4C"

export default level_4 = () ->
    return level("4", [
        level_4A(),
        label("Логарифмические сортировки"),
        label("Динамическое программирование: баяны"),
        label("Связные списки"),
        label("Хранение графов списками смежности"),
        level_4B(),
        label("Алгоритм Дейкстры"),
        label("Сортировка подсчетом"),
        label("Длинная арифметика"),
        label("Сортировка событий"),
        level_4C(),
    ])