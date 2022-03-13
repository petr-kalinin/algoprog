import label from "../lib/label"
import level from "../lib/level"
import level_0A from "./level_0A"
import level_0B from "./level_0B"
import level_0C from "./level_0C"
import level_0D from "./level_0D"

export default level_0 = () ->
    return level("0", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">\n\nЧтобы перейти на следующий уровень, необходимо решить все задачи.</div></div></div></div></div></div>"),
        level_0A(),
        level_0B(),
        level_0C(),
        level_0D(),
    ])