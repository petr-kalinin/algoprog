import level from "../lib/level"
import level_nnoi2016 from "./level_nnoi2016"
import level_nnoi2018 from "./level_nnoi2018"
import level_nnoi2019 from "./level_nnoi2019"
import level_nnoi2020 from "./level_nnoi2020"
import level_nnoi2021 from "./level_nnoi2021"

export default level_nnoi = () ->
    return level("nnoi", "Нижегородские городские олимпиады", [
        level_nnoi2016(),
        level_nnoi2018(),
        level_nnoi2019(),
        level_nnoi2020(),
        level_nnoi2021(),
])