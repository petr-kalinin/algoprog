import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

export default () ->
    return contest("2019", [
        problem({testSystem: "codeforces", contest: "gym/102112", problem: "A"}),
        problem({testSystem: "codeforces", contest: "gym/102112", problem: "B"}),
        problem({testSystem: "codeforces", contest: "gym/102112", problem: "C"}),
        problem({testSystem: "codeforces", contest: "gym/102112", problem: "D"}),
        problem({testSystem: "codeforces", contest: "gym/102112", problem: "E"}),
        problem({testSystem: "codeforces", contest: "gym/102112", problem: "F"}),
    ])
