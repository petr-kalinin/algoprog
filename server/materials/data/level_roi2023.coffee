import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

roi2023_1 = () ->
    return contest("2023, 1 тур", [
        problem({testSystem: "codeforces", contest: "gym/104290", problem: "1", name: "Видеонаблюдение"}),
        problem({testSystem: "codeforces", contest: "gym/104290", problem: "2", name: "Тайное послание"}),
        problem({testSystem: "codeforces", contest: "gym/104290", problem: "3", name: "Рекорды и антирекорды"}),
        problem({testSystem: "codeforces", contest: "gym/104290", problem: "4", name: "Ультра mex"}),
    ])

roi2023_2 = () ->
    return contest("2023, 2 тур", [
        problem({testSystem: "codeforces", contest: "gym/104291", problem: "5", name: "Улитка на склоне"}),
        problem({testSystem: "codeforces", contest: "gym/104291", problem: "6", name: "Конференция"}),
        problem({testSystem: "codeforces", contest: "gym/104291", problem: "7", name: "Яблоки по корзинам"}),
        problem({testSystem: "codeforces", contest: "gym/104291", problem: "8", name: "Выполнить план, но не перевыполнить"}),
    ])

export default level_roi2023 = () ->
    return level("roi2023", "2023", [
        roi2023_1(),
        roi2023_2(),
    ])