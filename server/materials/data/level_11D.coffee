import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import {ruen, levelDtitle, levelDmessage, levelDid} from '../lib/util'

contest_1 = () ->
    return contest(levelDtitle(1), [
        problem({testSystem: "codeforces", contest: "653", problem: "D"}),
        problem({testSystem: "codeforces", contest: "650", problem: "C"}),
        problem({testSystem: "codeforces", contest: "620", problem: "E"}),
        problem({testSystem: "codeforces", contest: "620", problem: "D"}),
        problem({testSystem: "codeforces", contest: "618", problem: "D"}),
        problem({testSystem: "codeforces", contest: "617", problem: "E"}),
    ])

contest_2 = () ->
    return contest(levelDtitle(2), [
        problem({testSystem: "codeforces", contest: "616", problem: "E"}),
        problem({testSystem: "codeforces", contest: "615", problem: "E"}),
        problem({testSystem: "codeforces", contest: "612", problem: "E"}),
        problem({testSystem: "codeforces", contest: "609", problem: "E"}),
        problem({testSystem: "codeforces", contest: "603", problem: "C"}),
        problem({testSystem: "codeforces", contest: "601", problem: "B"}),
    ])

contest_3 = () ->
    return contest(levelDtitle(3), [
        problem({testSystem: "codeforces", contest: "593", problem: "C"}),
        problem({testSystem: "codeforces", contest: "592", problem: "D"}),
        problem({testSystem: "codeforces", contest: "590", problem: "C"}),
        problem({testSystem: "codeforces", contest: "590", problem: "B"}),
        problem({testSystem: "codeforces", contest: "587", problem: "C"}),
        problem({testSystem: "codeforces", contest: "587", problem: "B"}),
    ])

export default level_11D = () ->
    return level(levelDid(11), [
        label(levelDmessage),
        contest_1(),
        contest_2(),
        contest_3(),
    ])