import label from "../../lib/label"
import level from "../../lib/level"
import level_7A from "./level_7A"
import level_7B from "./level_7B"
import level_7C from "./level_7C"

export default level_7 = () ->
    return level("7", [
        level_7A(),
        label("Сложные задачи на поиск в глубину"),
        label("Алгоритм Кнута-Морриса-Пратта (КМП)"),
        label("Z-функция"),
        level_7B(),
        label("Sqrt-декомпозиция, она же корневая эвристика"),
        label("Дерево отрезков"),
        label("Декартово дерево"),
        level_7C(),
    ])