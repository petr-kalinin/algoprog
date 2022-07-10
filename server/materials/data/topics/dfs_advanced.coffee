import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default dfs_advanced = () ->
    return {
        topic: topic(
            ruen("Сложные задачи на поиск в глубину", "Difficult tasks to search in depth"),
            ruen("Сложные задачи на поиск в глубину", "Difficult tasks to search in depth"),
        [label("<p>Теория вся есть в том же тексте про поиск в глубину (ссылка выше на уровне 3), только теперь вам уже надо знать тут вообще всё.</p>\n<p>Еще можете посмотреть на e-maxx, в частности, там есть <a href=\"https://e-maxx.ru/algo/strong_connected_components\">простое доказательство алгоритма построения сильносвязных компонент</a>.</p>"),
            problem(111689),
            problem(111690),
            problem(1991),
            problem(3883),
            problem(390),
            problem(932)
        ], "dfs_advanced"),
        advancedProblems: [
            problem(113441),
            problem(3360),
            problem(21),
            problem(3388),
            problem(112597),
            problem(1746),
            problem(573),
        ]
    }