import level from "../lib/level"
import level_1C from "./level_1C"
import level_1D from "./level_1D"

export default level_1 = () ->
    return level("1", [
        level_1A(),
        level_1B(),
        level_1C(),
        level_1D(),
    ])