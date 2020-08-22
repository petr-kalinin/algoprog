import level from "../lib/level"
import level_3A from "./level_3A"
import level_3B from "./level_3B"
import level_3C from "./level_3C"

export default level_3 = () ->
    return level("3", [
        level_3A(),
        level_3B(),
        level_3C(),
    ])