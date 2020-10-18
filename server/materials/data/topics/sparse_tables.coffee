import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default sparse_tables = () ->
    return {
        topic: topic("Sparse tables, двоичный подъем", "Задачи на sparse tables", [
            label("TODO"),
            problem(113919),
            problem(113550),
        ], "sparse_tables"),
    }