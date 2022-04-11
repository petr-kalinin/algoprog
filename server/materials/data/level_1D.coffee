import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_dfs = () ->
    return contest("1D: DFS", [
        problem({testSystem: "codeforces", contest: "522", problem: "A", name: "Репосты"}),
        problem({testSystem: "codeforces", contest: "277", problem: "A", name: "Изучение языков"}),
    ])


export default level_1D = () ->
    return level("1D", [
        label("Теоретический материал DFS:&nbsp;<a href=\"https://youtu.be/FQJCuxKpGBg\" target=\"_blank\">https://youtu.be/FQJCuxKpGBg</a>"),
        contest_dfs(),
    ])
