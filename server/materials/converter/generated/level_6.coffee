import level from "../../lib/level"
import level_6A from "./level_6A"
import level_6B from "./level_6B"
import level_6C from "./level_6C"

export default level_6 = () ->
    return level("6", [
        level_6A(),
        level_6B(),
        level_6C(),
    ])