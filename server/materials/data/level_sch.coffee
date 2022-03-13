import label from "../lib/label"
import level from "../lib/level"
import level_sch2021 from "./level_sch2021"

export default level_reg = () ->
    return level("sch", "Школьные олимпиады", [
        label("<p>C 2020 года олимпиады проводятся на платформе Сириус, с 2021 г. задачи доступны на Codeforces.</p>"),
        level_sch2021(),
])