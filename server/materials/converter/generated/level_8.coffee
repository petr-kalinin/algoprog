import label from "../../lib/label"
import level from "../../lib/level"
import level_8A from "./level_8A"
import level_8B from "./level_8B"
import level_8C from "./level_8C"

export default level_8 = () ->
    return level("8", [
        level_8A(),
        label("Системы непересекающихся множеств и минимальный остов"),
        label("Паросочетания и связанные темы"),
        label("Функция Гранди"),
        level_8B(),
        label("Сложные задачи на ДП"),
        label("Декартово дерево по неявному ключу"),
        label("Геометрия средней сложности"),
        level_8C(),
    ])