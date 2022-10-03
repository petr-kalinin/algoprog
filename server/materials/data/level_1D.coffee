import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import {ruen, levelDtitle, levelDmessage, levelDid} from '../lib/util'

contest_15993 = () ->
    return contest(levelDtitle(1), [
        problem({testSystem: "ejudge", contest: "3015", problem: "1", id: "3469"}),
        problem({testSystem: "ejudge", contest: "3015", problem: "2", id: "3466"}),
        problem({testSystem: "ejudge", contest: "3015", problem: "3", id: "3477"}),
        problem({testSystem: "ejudge", contest: "3015", problem: "4", id: "3472"}),
        problem({testSystem: "ejudge", contest: "3015", problem: "5", id: "2954"}),
        problem({testSystem: "ejudge", contest: "3015", problem: "6", id: "1370"}),
        problem({testSystem: "codeforces", contest: "381", problem: "B"}),
    ])

contest_15994 = () ->
    return contest(levelDtitle(2), [
        problem(111499),
        problem(3888),
        problem(3893),
        problem({testSystem: "ejudge", contest: "3016", problem: "1", id: "507"}),
        problem({testSystem: "ejudge", contest: "3016", problem: "2", id: "511"}),
        problem({testSystem: "ejudge", contest: "3016", problem: "3", id: "482"}),
        problem({testSystem: "ejudge", contest: "3016", problem: "4", id: "483"}),
    ])

contest_15996 = () ->
    return contest(levelDtitle(3), [
        problem({testSystem: "ejudge", contest: "3017", problem: "1", id: "1421"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "2", id: "3745"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "3", id: "1406"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "4", id: "592"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "5", id: "1209"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "6", id: "855"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "7", id: "1435"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "8", id: "993"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "9", id: "111580"}),
        problem({testSystem: "ejudge", contest: "3017", problem: "10", id: "2958"}),
    ])

export default level_1D = () ->
    return level(levelDid(1), [
        label(levelDmessage),
        contest_15993(),
        contest_15994(),
        contest_15996(),
    ])