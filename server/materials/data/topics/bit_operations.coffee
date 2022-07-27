import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default bit_operations = () ->
    return {
        topic: topic(
            ruen("Битовые операции", "Bit operations"),
            ruen("Задачи на битовые операции", "Problems on bit operations"),
        [label(ruen("""<p>Теория: <a href='https://notes.algoprog.ru/shortideas/03_5_bitandor.html'>основная</a>, дополнительно:
            <a href='https://server.179.ru/tasks/python/2014b1/22-bits.html'>раз</a>, <a href='https://ravesli.com/urok-45-pobitovye-operatory/'>два</a>.
            Тут везде разные языки программирования, но принцип один и тот же, максимум операции могут по-разному записываться.</p>""",
            """<p>Theory: <a href='https://notes.algoprog.ru/shortideas/03_5_bitandor.html '>main</a>, optional:
            <a href='https://server.179.ru/tasks/python/2014b1/22-bits.html '>one</a>, <a href='https://ravesli.com/urok-45-pobitovye-operatory /'>two</a>.
            There are different programming languages everywhere, but the principle is the same, only the operation notation can be different.</p>""")),
            problem(123),
            problem(128),
            problem(111588),
            problem({testSystem: "ejudge", contest: "2001", problem: "4"}),
        ], "bit_operations"),
        advancedProblems: [
            problem(111521),
            problem(122),
            problem({testSystem: "codeforces", contest: "1303", problem: "D"}),
        ]
    }
