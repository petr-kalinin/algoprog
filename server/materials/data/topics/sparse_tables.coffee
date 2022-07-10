import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default sparse_tables = () ->
    return {
        topic: topic(
            ruen("Sparse tables, двоичный подъем", "Sparse tables, binary ascent"),
            ruen("Задачи на sparse tables", "Problems on sparse tables"),
        [label("TODO"),
            problem(113919),
            problem(113550),
        ], "sparse_tables"),
    }