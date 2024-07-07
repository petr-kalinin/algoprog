import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

reg2024_1 = () ->
    return contest("2024, 1 тур", [
        problem({testSystem: "codeforces", contest: "gym/104949", problem: "1", name: "Посадка в самолёт"}),
        problem({testSystem: "codeforces", contest: "gym/104949", problem: "2", name: "Битоническая последовательность"}),
        problem({testSystem: "codeforces", contest: "gym/104949", problem: "3", name: "Игра с таблицей"}),
        problem({testSystem: "codeforces", contest: "gym/104949", problem: "4", name: "Выбор столицы"}),
    ])

reg2024_2 = () ->
    return contest("2024, 2 тур", [
        problem({testSystem: "codeforces", contest: "gym/104950", problem: "5", name: "Разбиение массива"}),
        problem({testSystem: "codeforces", contest: "gym/104950", problem: "6", name: "Бактерии"}),
        problem({testSystem: "codeforces", contest: "gym/104950", problem: "7", name: "Разбиение на тройки"}),
        problem({testSystem: "codeforces", contest: "gym/104950", problem: "8", name: "Обходы бинарного дерева"}),
    ])

export default level_reg2024 = () ->
    return level("reg2024", "2024", [
        reg2024_1(),
        reg2024_2(),
    ])