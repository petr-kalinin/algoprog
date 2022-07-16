import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import {ruen, levelDtitle, levelDmessage, levelDid} from '../lib/util'

contest_1 = () ->
    return contest(levelDtitle(1), [
        problem({testSystem: "codeforces", contest: "908", problem: "C"}),
        problem({testSystem: "codeforces", contest: "906", problem: "A"}),
        problem({testSystem: "codeforces", contest: "901", problem: "A"}),
        problem({testSystem: "codeforces", contest: "898", problem: "E"}),
        problem({testSystem: "codeforces", contest: "858", problem: "D"}),
        problem({testSystem: "codeforces", contest: "856", problem: "A"}),
    ])

contest_2 = () ->
    return contest(levelDtitle(2), [
        problem({testSystem: "codeforces", contest: "891", problem: "A"}),
        problem({testSystem: "codeforces", contest: "888", problem: "D"}),
        problem({testSystem: "codeforces", contest: "887", problem: "C"}),
        problem({testSystem: "codeforces", contest: "884", problem: "C"}),
        problem({testSystem: "codeforces", contest: "993", problem: "A"}),
        problem({testSystem: "codeforces", contest: "878", problem: "A"}),
    ])

contest_3 = () ->
    return contest(levelDtitle(3), [
        problem({testSystem: "codeforces", contest: "877", problem: "C"}),
        problem({testSystem: "codeforces", contest: "877", problem: "B"}),
        problem({testSystem: "codeforces", contest: "875", problem: "B"}),
        problem({testSystem: "codeforces", contest: "873", problem: "C"}),
        problem({testSystem: "codeforces", contest: "873", problem: "B"}),
        problem({testSystem: "codeforces", contest: "868", problem: "C"}),
    ])

export default level_5D = () ->
    return level(levelDid(5), [
        label(levelDmessage),
        contest_1(),
        contest_2(),
        contest_3(),
    ])