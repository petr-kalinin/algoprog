import level from "../../lib/level"
import level_4A from "./level_4A"
import level_4B from "./level_4B"
import level_4C from "./level_4C"

export default level_4 = () ->
    return level("4", [
        level_4A(),
        level_4B(),
        level_4C(),
    ])