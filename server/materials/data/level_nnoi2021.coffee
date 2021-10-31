import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

export default nnoi2021 = () ->
    return contest("2021", [
        problem({testSystem: "codeforces", contest: "gym/103262", problem: "A"}),
        problem({testSystem: "codeforces", contest: "gym/103262", problem: "B"}),
        problem({testSystem: "codeforces", contest: "gym/103262", problem: "C"}),
        problem({testSystem: "codeforces", contest: "gym/103262", problem: "D", name: "Магические посохи"}),
        problem({testSystem: "codeforces", contest: "gym/103262", problem: "E", name: "Проектор"}),
        problem({testSystem: "codeforces", contest: "gym/103262", problem: "F"}),
    ])
