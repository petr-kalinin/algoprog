import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import {ruen, levelDtitle, levelDmessage, levelDid} from '../lib/util'

contest_1 = () ->
    return contest(levelDtitle(1), [
        problem({testSystem: "codeforces", contest: "687", problem: "C"}),
        problem({testSystem: "codeforces", contest: "685", problem: "B"}),
        problem({testSystem: "codeforces", contest: "682", problem: "D"}),
        problem({testSystem: "codeforces", contest: "681", problem: "D"}),
        problem({testSystem: "codeforces", contest: "676", problem: "D"}),
        problem({testSystem: "codeforces", contest: "671", problem: "B"}),
    ])

contest_2 = () ->
    return contest(levelDtitle(2), [
        problem({testSystem: "codeforces", contest: "666", problem: "B"}),
        problem({testSystem: "codeforces", contest: "662", problem: "D"}),
        problem({testSystem: "codeforces", contest: "660", problem: "D"}),
        problem({testSystem: "codeforces", contest: "659", problem: "F"}),
        problem({testSystem: "codeforces", contest: "653", problem: "C"}),
        problem({testSystem: "codeforces", contest: "650", problem: "B"}),
    ])

contest_3 = () ->
    return contest(levelDtitle(3), [
        problem({testSystem: "codeforces", contest: "641", problem: "E"}),
        problem({testSystem: "codeforces", contest: "633", problem: "D"}),
        problem({testSystem: "codeforces", contest: "633", problem: "C"}),
        problem({testSystem: "codeforces", contest: "630", problem: "O"}),
        problem({testSystem: "codeforces", contest: "629", problem: "D"}),
        problem({testSystem: "codeforces", contest: "622", problem: "D"}),
    ])

export default level_9D = () ->
    return level(levelDid(9), [
        label(levelDmessage),
        contest_1(),
        contest_2(),
        contest_3(),
    ])