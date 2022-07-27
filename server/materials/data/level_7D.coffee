import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import {ruen, levelDtitle, levelDmessage, levelDid} from '../lib/util'

contest_1 = () ->
    return contest(levelDtitle(1), [
        problem({testSystem: "codeforces", contest: "732", problem: "D"}),
        problem({testSystem: "codeforces", contest: "761", problem: "D"}),
        problem({testSystem: "codeforces", contest: "758", problem: "C"}),
        problem({testSystem: "codeforces", contest: "729", problem: "D"}),
        problem({testSystem: "codeforces", contest: "727", problem: "D"}),
        problem({testSystem: "codeforces", contest: "725", problem: "D"}),
    ])

contest_2 = () ->
    return contest(levelDtitle(2), [
        problem({testSystem: "codeforces", contest: "724", problem: "C"}),
        problem({testSystem: "codeforces", contest: "721", problem: "C"}),
        problem({testSystem: "codeforces", contest: "718", problem: "A"}),
        problem({testSystem: "codeforces", contest: "711", problem: "C"}),
        problem({testSystem: "codeforces", contest: "706", problem: "D"}),
        problem({testSystem: "codeforces", contest: "700", problem: "B"}),
    ])

contest_3 = () ->
    return contest(levelDtitle(3), [
        problem({testSystem: "codeforces", contest: "698", problem: "B"}),
        problem({testSystem: "codeforces", contest: "696", problem: "B"}),
        problem({testSystem: "codeforces", contest: "691", problem: "D"}),
        problem({testSystem: "codeforces", contest: "691", problem: "C"}),
        problem({testSystem: "codeforces", contest: "765", problem: "D"}),
        problem({testSystem: "codeforces", contest: "689", problem: "C"}),
    ])

export default level_7D = () ->
    return level(levelDid(7), [
        label(levelDmessage),
        contest_1(),
        contest_2(),
        contest_3(),
    ])