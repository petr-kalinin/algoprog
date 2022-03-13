import link from "../../lib/link"
import main from "../../lib/main"
import level_0 from "./level_0"
import level_1 from "./level_1"
import level_2 from "./level_2"
import level_about from "./level_about"
import level_reg from "./level_reg"
import level_roi from "./level_roi"
import allNews from "./news"

export default root = () ->
    return main([
        level_about(),
        allNews(),
        link("/comments", "Комментарии"),
        level_0(),
        level_1(),
        level_2(),
        level_reg(),
        level_roi(),
    ])