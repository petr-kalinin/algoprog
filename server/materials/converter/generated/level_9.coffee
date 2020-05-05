import label from "../../lib/label"
import level from "../../lib/level"
import level_9A from "./level_9A"
import level_9B from "./level_9B"
import level_9C from "./level_9C"

export default level_9 = () ->
    return level("9", [
        level_9A(),
        label("Простые потоки"),
        label("Дерево Фенвика"),
        label("LCA"),
        level_9B(),
        label("Групповые операции на деревьях"),
        label("Бор и алгоритм Ахо-Корасик"),
        label("Многомерные деревья"),
        level_9C(),
    ])