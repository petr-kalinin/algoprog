import level from "../../lib/level"
import level_10A from "./level_10A"
import level_10B from "./level_10B"
import level_10C from "./level_10C"

export default level_10 = () ->
    return level("10", [
        level_10A(),
        level_10B(),
        level_10C(),
    ])