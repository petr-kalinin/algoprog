import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

reg2020_1 = () ->
    return contest("2020, 1 тур", [
        problem({testSystem: "codeforces", contest: "gym/102479", problem: "1"}),
        problem({testSystem: "codeforces", contest: "gym/102479", problem: "2", name: "Превышение скорости"}),
        problem({testSystem: "codeforces", contest: "gym/102479", problem: "3", name: "Борьба с рутиной"}),
        problem({testSystem: "codeforces", contest: "gym/102479", problem: "4", name: "Олимпиада для роботов"}),
    ])

reg2020_2 = () ->
    return contest("2020, 2 тур", [
        problem({testSystem: "codeforces", contest: "gym/102480", problem: "5", name: "Максимальное произведение"}),
        problem({testSystem: "codeforces", contest: "gym/102480", problem: "6", name: "Планировка участка"}),
        problem({testSystem: "codeforces", contest: "gym/102480", problem: "7", name: "Банкомат"}),
        problem({testSystem: "codeforces", contest: "gym/102480", problem: "8", name: "Плакаты"}),
    ])

export default level_reg2020 = () ->
    return level("reg2020", "2020", [
        reg2020_1(),
        reg2020_2(),
    ])