import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default testing_advanced = () ->
    return {
        topic: topic(
            ruen("Продвинутое тестирование задач", null),
            null,
        [label(ruen(
                "<p>Перечитайте еще раз текст про тестирование задач из уровня 1В — вам он теперь наверняка еще более полезен, и вы можете освоить более продвинутые техники (если еще не освоили).</p>",
                # TODO: translate
                null)),
        ], "testing_advanced"),
        count: false
    }