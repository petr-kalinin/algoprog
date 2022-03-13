import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

export default () ->
    return contest("2018", [
        problem({testSystem: "codeforces", contest: "gym/103265", problem: "A"}),
        problem({testSystem: "codeforces", contest: "gym/103265", problem: "B"}),
        problem({testSystem: "codeforces", contest: "gym/103265", problem: "C"}),
        problem({testSystem: "codeforces", contest: "gym/103265", problem: "D"}),
        problem({testSystem: "codeforces", contest: "gym/103265", problem: "E"}),
        problem({testSystem: "codeforces", contest: "gym/103265", problem: "F"}),
    ])
