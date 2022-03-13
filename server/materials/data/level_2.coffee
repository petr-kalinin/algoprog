import label from "../lib/label"
import level from "../lib/level"
import level_2A from "./level_2A"

export default level_2 = () ->
    return level("2", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">\n\n</div></div></div></div></div></div>"),
        level_2A(),
    ])