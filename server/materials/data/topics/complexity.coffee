import contest from "../../lib/contest"
import label from "../../lib/label"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default complexity = () ->
    return {
        topic: topic(
            ruen("Сложность алгоритмов", "Complexity of algorithms"),
            null,
        [label(ruen(
                "<a href=\"https://notes.algoprog.ru/complexity/index.html\">Теория про сложность алгоритмов (читайте раздел «Простейшие основы», остальное пока не так важно)</a>",
                "<p>This is also a very wide topic. There are some links that may be useful for you, but you can also search for more information in the Internet:<br/>
                <a href=\"https://brainkart.com/article/Understanding-Algorithmic-Complexity_9399/\">Link one</a>,<br/>
                <a href='https://towardsdatascience.com/algorithmic-complexity-101-28b567cc335b'>Link two</a></p>
                <p>There is also a golden rule of complexity that is not mentioned on those links: <b>a typical modern computer performs about 100 million — 1 billion operations per second</b>. So, in order to estimate the running time of your code, substitute the maximal possible $N$ into the complexity formula, and divide by 100 million or 1 billion. The result will be the running time in seconds (very approximate, of course, but still useful). For example, if maximal $N$ is $1000$, then an $O(N^2)$ algorithm will run in ~0.001—0.01 seconds and most probably will fit into time limit. But if maximal $N$ is $100 000$, the runtime will be 10—100 seconds and will get a time limit exceeded outcome. (For python,
                the number of operations per second is 10-100 times less.) Use this rule to estimate whether a particular algorithm can be used in a particular problem.</p>
                ")),
        ], "complexity"),
        count: false
    }
