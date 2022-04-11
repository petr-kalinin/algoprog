import contest from "../lib/contest"
import level from "../lib/level"
import problem from "../lib/problem"

contest_dfs = () ->
    return contest("1D: DFS", [
        problem({testSystem: "codeforces", contest: "contest/522", problem: "A", name: "Репосты"}),
        problem({testSystem: "codeforces", contest: "contest/277", problem: "A", name: "Изучение языков"}),
    ])


export default level_1D = () ->
    return level("1D", [
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\"><p dir=\"ltr\" style=\"text-align: left;\"></p><br><p></p></div></div></div></div></div></div>"),
        label("<div><div class=\"mod-indent-outer w-100\"><div><div class=\"contentwithoutlink \"><div class=\"no-overflow\"><div class=\"no-overflow\">Теоретический материал DFS:&nbsp;<a href=\"https://youtu.be/FQJCuxKpGBg\" target=\"_blank\">https://youtu.be/FQJCuxKpGBg</a></div></div></div></div></div></div>"),
        contest_dfs(),
    ])