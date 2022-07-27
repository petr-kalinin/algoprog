import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import {ruen, levelDtitle, levelDmessage, levelDid} from '../lib/util'

contest_1 = () ->
    return contest(levelDtitle(1), [
        problem({testSystem: "codeforces", contest: "928", problem: "B"}),
        problem({testSystem: "codeforces", contest: "928", problem: "A"}),
        problem({testSystem: "codeforces", contest: "926", problem: "A"}),
        problem({testSystem: "codeforces", contest: "924", problem: "A"}),
        problem({testSystem: "codeforces", contest: "922", problem: "B"}),
        problem({testSystem: "codeforces", contest: "922", problem: "A"}),
    ])

contest_2 = () ->
    return contest(levelDtitle(2), [
        problem({testSystem: "codeforces", contest: "920", problem: "C"}),
        problem({testSystem: "codeforces", contest: "920", problem: "B"}),
        problem({testSystem: "codeforces", contest: "919", problem: "C"}),
        problem({testSystem: "codeforces", contest: "915", problem: "B"}),
        problem({testSystem: "codeforces", contest: "914", problem: "B"}),
        problem({testSystem: "codeforces", contest: "913", problem: "B"}),
    ])

contest_3 = () ->
    return contest(levelDtitle(3), [
        problem({testSystem: "codeforces", contest: "912", problem: "B"}),
        problem({testSystem: "codeforces", contest: "911", problem: "C"}),
        problem({testSystem: "codeforces", contest: "911", problem: "B"}),
        problem({testSystem: "codeforces", contest: "909", problem: "B"}),
        problem({testSystem: "codeforces", contest: "908", problem: "B"}),
        problem({testSystem: "codeforces", contest: "907", problem: "B"}),
    ])

export default level_3D = () ->
    return level(levelDid(3), [
        label(levelDmessage),
        contest_1(),
        contest_2(),
        contest_3(),
    ])