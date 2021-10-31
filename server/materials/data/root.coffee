import link from "../lib/link"
import main from "../lib/main"
import level_about from "./level_about"
import level_sch from "./level_sch"
import level_nnoi from "./level_nnoi"
import level_reg from "./level_reg"
import level_roi from "./level_roi"
import mainLevels from './mainLevels'
import allNews from "./news"
import tables from './tables'

export default root = () ->
    return main([
        level_about(),
        allNews(),
        link("/comments", "Комментарии"),
        link("/findMistakeList", "Найди ошибку"),
        mainLevels()...,
        level_sch(),
        level_nnoi(),
        level_reg(),
        level_roi(),
        tables()
    ])