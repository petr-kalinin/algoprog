import level from "../lib/level"
import level_8A from "./level_8A"
import level_8B from "./level_8B"
import level_8C from "./level_8C"

export default level_8 = () ->
    return level("8", [
        level_8A(),
        level_8B(),
        level_8C(),
    ])