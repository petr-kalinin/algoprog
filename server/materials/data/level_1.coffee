import label from "../lib/label"
import level from "../lib/level"
import level_1A from "./level_1A"
import level_1B from "./level_1B"
import level_1C from "./level_1C"
import level_1D from "./level_1D"

export default level_1 = () ->
    return level("1", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">\n\n\n\n</div></div></div></div></div></div>"),
        level_1A(),
        level_1B(),
        level_1C(),
        level_1D(),
    ])
