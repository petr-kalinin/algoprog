import label from "../../lib/label"
import level from "../../lib/level"
import level_6A from "./level_6A"
import level_6B from "./level_6B"
import level_6C from "./level_6C"

export default level_6 = () ->
    return level("6", [
        level_6A(),
        label("Алгоритмы Флойда и Форда-Беллмана"),
        label("Простые игры на графах"),
        label("Поиск в ширину в 1-k и 0-k графах"),
        level_6B(),
        label("Жадные алгоритмы"),
        label("Простая геометрия"),
        level_6C(),
    ])