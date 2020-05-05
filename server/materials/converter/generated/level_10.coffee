import label from "../../lib/label"
import level from "../../lib/level"
import level_10A from "./level_10A"
import level_10B from "./level_10B"
import level_10C from "./level_10C"

export default level_10 = () ->
    return level("10", [
        level_10A(),
        label("Продвинутая теория чисел, китайская теорема об остатках"),
        label("Суффиксные структуры данных"),
        label("Сложная геометрия"),
        level_10B(),
        label("Mincost-maxflow"),
        label("Паросочетание максимального веста, венгерский алгоритм"),
        label("Матрицы и их применение к ДП"),
        level_10C(),
    ])