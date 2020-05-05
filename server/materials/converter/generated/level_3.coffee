import label from "../../lib/label"
import level from "../../lib/level"
import level_3A from "./level_3A"
import level_3B from "./level_3B"
import level_3C from "./level_3C"

export default level_3 = () ->
    return level("3", [
        level_3A(),
        label("Проcтые графы"),
        label("Поиск в ширину"),
        label("Бинарный поиск (поиск делением пополам)"),
        level_3B(),
        label("Системы счисления. Двоичная система счисления."),
        label("Два указателя"),
        label("Основы поиска в глубину"),
        label("Продвинутое тестирование задач (без контеста)"),
        level_3C(),
    ])