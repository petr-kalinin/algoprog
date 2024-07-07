import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

reg2022_1 = () ->
    return contest("2022, 1 тур", [
        problem({testSystem: "codeforces", contest: "gym/103532", problem: "1", name: "Чемпионат по устному счету"}),
        problem({testSystem: "codeforces", contest: "gym/103532", problem: "2", name: "Прыгающий робот"}),
        problem({testSystem: "codeforces", contest: "gym/103532", problem: "3", name: "Треугольная головоломка"}),
        problem({testSystem: "codeforces", contest: "gym/103532", problem: "4", name: "Массивы-палиндромы"}),
    ])

reg2022_2 = () ->
    return contest("2022, 2 тур", [
        problem({testSystem: "codeforces", contest: "gym/103533", problem: "5", name: "Новый год в детском саду"}),
        problem({testSystem: "codeforces", contest: "gym/103533", problem: "6", name: "Сортировка дробей"}),
        problem({testSystem: "codeforces", contest: "gym/103533", problem: "7", name: "Оптические каналы связи"}),
        problem({testSystem: "codeforces", contest: "gym/103533", problem: "8", name: "Подарки"}),
    ])

export default level_reg2022 = () ->
    return level("reg2022", "2022", [
        reg2022_1(),
        reg2022_2(),
    ])