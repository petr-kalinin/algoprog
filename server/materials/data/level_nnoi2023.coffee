import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

export default nnoi2023 = () ->
    return contest("2023", [
        problem({testSystem: "codeforces", contest: "gym/105151", problem: "A"}),
        problem({testSystem: "codeforces", contest: "gym/105151", problem: "B"}),
        problem({testSystem: "codeforces", contest: "gym/105151", problem: "C"}),
        problem({testSystem: "codeforces", contest: "gym/105151", problem: "D"}),
        problem({testSystem: "codeforces", contest: "gym/105151", problem: "E"}),
        problem({testSystem: "codeforces", contest: "gym/105151", problem: "F"}),
        problem({testSystem: "codeforces", contest: "gym/105151", problem: "G"}),
        problem({testSystem: "codeforces", contest: "gym/105151", problem: "H"}),
    ])
