import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

export default () ->
    return contest("2020", [
        problem({testSystem: "codeforces", contest: "gym/103264", problem: "A", name: "Нейросеть"}),
        problem({testSystem: "codeforces", contest: "gym/103264", problem: "B"}),
        problem({testSystem: "codeforces", contest: "gym/103264", problem: "C"}),
        problem({testSystem: "codeforces", contest: "gym/103264", problem: "D"}),
        problem({testSystem: "codeforces", contest: "gym/103264", problem: "E"}),
        problem({testSystem: "codeforces", contest: "gym/103264", problem: "F"}),
    ])
