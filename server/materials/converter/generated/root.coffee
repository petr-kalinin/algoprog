import link from "../../lib/link"
import main from "../../lib/main"
import level_1 from "./level_1"
import level_10 from "./level_10"
import level_2 from "./level_2"
import level_3 from "./level_3"
import level_4 from "./level_4"
import level_5 from "./level_5"
import level_6 from "./level_6"
import level_7 from "./level_7"
import level_8 from "./level_8"
import level_9 from "./level_9"
import level_about from "./level_about"
import level_reg from "./level_reg"
import level_roi from "./level_roi"
import allNews from "./news"

export default root = () ->
    return main([
        level_about(),
        allNews(),
        link("/comments", "Комментарии"),
        level_1(),
        level_2(),
        level_3(),
        level_4(),
        level_5(),
        level_6(),
        level_7(),
        level_8(),
        level_9(),
        level_10(),
        level_reg(),
        level_roi(),
    ])