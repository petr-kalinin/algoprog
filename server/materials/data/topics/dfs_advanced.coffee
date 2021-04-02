import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default dfs_advanced = () ->
    return {
        topic: topic("Сложные задачи на поиск в глубину", "Сложные задачи на поиск в глубину", [
            label("<p>Теория вся есть в том же тексте про поиск в глубину (ссылка выше на уровне 3), только теперь вам уже надо знать тут вообще всё.</p>\n<p>Еще можете посмотреть на e-maxx, в частности, там есть <a href=\"https://e-maxx.ru/algo/strong_connected_components\">простое доказательство алгоритма построения сильносвязных компонент</a>.</p>"),
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