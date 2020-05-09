import level from "../../lib/level"
import level_7A from "./level_7A"
import level_7B from "./level_7B"
import level_7C from "./level_7C"

export default level_7 = () ->
    return level("7", [
        level_7A(),
        level_7B(),
        level_7C(),
    ])