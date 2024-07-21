import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

reg2023_1 = () ->
    return contest("2023, 1 тур", [
        problem({testSystem: "codeforces", contest: "gym/104155", problem: "1", name: "Разделение прямоугольника"}),
        problem({testSystem: "codeforces", contest: "gym/104155", problem: "2", name: "Произведение Фиббоначи"}),
        problem({testSystem: "codeforces", contest: "gym/104155", problem: "3", name: "Робот-пылесос"}),
        problem({testSystem: "codeforces", contest: "gym/104155", problem: "4", name: "Разноцветные точки"}),
    ])

reg2023_2 = () ->
    return contest("2023, 2 тур", [
        problem({testSystem: "codeforces", contest: "gym/104156", problem: "5", name: "Метрострой"}),
        problem({testSystem: "codeforces", contest: "gym/104156", problem: "6", name: "Красивые последовательности"}),
        problem({testSystem: "codeforces", contest: "gym/104156", problem: "7", name: "Камни"}),
        problem({testSystem: "codeforces", contest: "gym/104156", problem: "8", name: "Обыкновенная задача про строки"}),
    ])

export default level_reg2023 = () ->
    return level("reg2023", "2023", [
        reg2023_1(),
        reg2023_2(),
    ])