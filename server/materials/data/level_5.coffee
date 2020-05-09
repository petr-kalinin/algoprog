import level from "../lib/level"
import level_5A from "./level_5A"
import level_5B from "./level_5B"
import level_5C from "./level_5C"

export default level_5 = () ->
    return level("5", [
        level_5A(),
        level_5B(),
        level_5C(),
    ])