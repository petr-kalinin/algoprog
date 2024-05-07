import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

export default nnoi2022 = () ->
    return contest("2022", [
        problem({testSystem: "codeforces", contest: "gym/105150", problem: "A"}),
        problem({testSystem: "codeforces", contest: "gym/105150", problem: "B", name: "Налоги"}),
        problem({testSystem: "codeforces", contest: "gym/105150", problem: "C", name: "Карта кобры"}),
        problem({testSystem: "codeforces", contest: "gym/105150", problem: "D"}),
        problem({testSystem: "codeforces", contest: "gym/105150", problem: "E"}),
        problem({testSystem: "codeforces", contest: "gym/105150", problem: "F"}),
        problem({testSystem: "codeforces", contest: "gym/105150", problem: "G"}),
    ])
