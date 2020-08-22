import level from "../lib/level"
import level_2A from "./level_2A"
import level_2B from "./level_2B"
import level_2C from "./level_2C"

export default level_2 = () ->
    return level("2", [
        level_2A(),
        level_2B(),
        level_2C(),
    ])