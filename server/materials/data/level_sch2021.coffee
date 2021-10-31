import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"

sch2021_1 = () ->
    return contest("2021, группа регионов 1", [
        problem({testSystem: "codeforces", contest: "gym/103385", problem: "1"}),
        problem({testSystem: "codeforces", contest: "gym/103385", problem: "2"}),
        problem({testSystem: "codeforces", contest: "gym/103385", problem: "3"}),
        problem({testSystem: "codeforces", contest: "gym/103385", problem: "4"}),
        problem({testSystem: "codeforces", contest: "gym/103385", problem: "5"}),
    ])

sch2021_2 = () ->
    return contest("2021, группа регионов 2", [
        problem({testSystem: "codeforces", contest: "gym/103384", problem: "1"}),
        problem({testSystem: "codeforces", contest: "gym/103384", problem: "2"}),
        problem({testSystem: "codeforces", contest: "gym/103384", problem: "3"}),
        problem({testSystem: "codeforces", contest: "gym/103384", problem: "4"}),
        problem({testSystem: "codeforces", contest: "gym/103384", problem: "5"}),
    ])

sch2021_3 = () ->
    return contest("2021, группа регионов 3", [
        problem({testSystem: "codeforces", contest: "gym/103382", problem: "1"}),
        problem({testSystem: "codeforces", contest: "gym/103382", problem: "2"}),
        problem({testSystem: "codeforces", contest: "gym/103382", problem: "3"}),
        problem({testSystem: "codeforces", contest: "gym/103382", problem: "4"}),
        problem({testSystem: "codeforces", contest: "gym/103382", problem: "5"}),
    ])

sch2021_4 = () ->
    return contest("2021, группа регионов 4", [
        problem({testSystem: "codeforces", contest: "gym/103383", problem: "1"}),
        problem({testSystem: "codeforces", contest: "gym/103383", problem: "2"}),
        problem({testSystem: "codeforces", contest: "gym/103383", problem: "3"}),
        problem({testSystem: "codeforces", contest: "gym/103383", problem: "4"}),
        problem({testSystem: "codeforces", contest: "gym/103383", problem: "5"}),
    ])

export default level_school2021 = () ->
    return level("sch2021", "2021", [
        label("Нижегородская область относилась ко 2 группе регионов")
        sch2021_1(),
        sch2021_2(),
        sch2021_2(),
        sch2021_2(),
    ])