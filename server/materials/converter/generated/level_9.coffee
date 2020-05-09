import level from "../../lib/level"
import level_9A from "./level_9A"
import level_9B from "./level_9B"
import level_9C from "./level_9C"

export default level_9 = () ->
    return level("9", [
        level_9A(),
        level_9B(),
        level_9C(),
    ])