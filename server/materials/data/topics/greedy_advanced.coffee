import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default greedy_2 = () ->
    return {
        topic: topic(
            ruen("Жадные алгоритмы", "Greedy algorithms"),
            ruen("Задачи на жадность", "Problems on greed"),
        [label(ruen(
             "<p><a href=\"http://www.williamspublishing.com/PDF/5-8459-0857-4/part.pdf\">Очень продвинутая теория</a> (вообще для задач ниже, да и в принципе по жизни, эта теория не особо нужна, можете прочитать \"для сведения\", но в принципе понимать про матроиды, а также про коды Хаффмана полезно). Еще вспомните теорию с уровня 2Б, и можете еще погуглить.</p>",
             "<p><a href=\"http://www.williamspublishing.com/PDF/5-8459-0857-4/part.pdf\">A very advanced theory</a> (in general, for the tasks below, and in principle in life, this theory is not particularly needed, you can read \"for information\", but in principle it is useful to understand about matroids, as well as about Huffman codes). Also remember the theory from level 2B, and you can still Google.</p>")),
            problem(3356),
            problem(3380),
            problem(3589),
            problem(411),
            problem(1744),
            problem(2978),
        ], "greedy_advanced"),
        advancedProblems: [
            problem(1987),
            problem(1782),
            problem(641),
            problem(583),
            problem(112096),
        ]
    }