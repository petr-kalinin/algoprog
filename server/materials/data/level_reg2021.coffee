import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

reg2021_1 = () ->
    return contest("2021, 1 тур", [
        problem({testSystem: "codeforces", contest: "gym/102935", problem: "1", name: "Два станка"}),
        problem({testSystem: "codeforces", contest: "gym/102935", problem: "2", name: "Разбиение таблицы"}),
        problem({testSystem: "codeforces", contest: "gym/102935", problem: "3", name: "Изменённая ДНК"}),
        problem({testSystem: "codeforces", contest: "gym/102935", problem: "4", name: "Антенна"}),
    ])

reg2021_2 = () ->
    return contest("2021, 2 тур", [
        problem({testSystem: "codeforces", contest: "gym/102936", problem: "5", name: "Календарь на Альфе Центавра"}),
        problem({testSystem: "codeforces", contest: "gym/102936", problem: "6", name: "Числа"}),
        problem({testSystem: "codeforces", contest: "gym/102936", problem: "7", name: "Хорошие раскраски"}),
        problem({testSystem: "codeforces", contest: "gym/102936", problem: "8", name: "A+B"}),
    ])

export default level_reg2021 = () ->
    return level("reg2021", "2021", [
        reg2021_1(),
        reg2021_2(),
    ])