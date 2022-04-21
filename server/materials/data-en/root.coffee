import link from "../lib/link"
import main from "../lib/main"

import level_about from "./level_about"
import mainLevels from './mainLevels'
import allNews from "./news"
import tables from './tables'

export default root = () ->
    return main([
        level_about(),
        allNews(),
        link("/comments", "Comments"),
        link("/findMistakeList", "Find mistake"),
        mainLevels()...,
        tables()
    ])