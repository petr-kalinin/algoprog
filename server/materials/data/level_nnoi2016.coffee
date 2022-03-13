import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

export default () ->
    return contest("2016", [
        problem({testSystem: "codeforces", contest: "gym/100885", problem: "A"}),
        problem({testSystem: "codeforces", contest: "gym/100885", problem: "B"}),
        problem({testSystem: "codeforces", contest: "gym/100885", problem: "C"}),
        problem({testSystem: "codeforces", contest: "gym/100885", problem: "D"}),
        problem({testSystem: "codeforces", contest: "gym/100885", problem: "E"}),
        problem({testSystem: "codeforces", contest: "gym/100885", problem: "F"}),
    ])
