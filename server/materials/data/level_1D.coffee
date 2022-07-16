import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import {ruen, levelDtitle, levelDmessage, levelDid} from '../lib/util'

contest_15993 = () ->
    return contest(levelDtitle(1), [
        problem(3469),
        problem(3466),
        problem(3477),
        problem(3472),
        problem(2954),
        problem(1370),
        problem({testSystem: "codeforces", contest: "381", problem: "B"}),
    ])

contest_15994 = () ->
    return contest(levelDtitle(2), [
        problem(111499),
        problem(3888),
        problem(3893),
        problem(507),
        problem(511),
        problem(482),
        problem(483),
    ])

contest_15996 = () ->
    return contest(levelDtitle(3), [
        problem(1421),
        problem(3745),
        problem(1406),
        problem(592),
        problem(1209),
        problem(855),
        problem(1435),
        problem(993),
        problem(111580),
        problem(2958),
    ])

export default level_1D = () ->
    return level(levelDid(1), [
        label(levelDmessage),
        contest_15993(),
        contest_15994(),
        contest_15996(),
    ])