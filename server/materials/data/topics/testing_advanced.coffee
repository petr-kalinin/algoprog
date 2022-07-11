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
            ruen("Продвинутое тестирование задач", "Advanced task testing"),
            null,
        [label(ruen(
                "<p>Перечитайте еще раз текст про тестирование задач из уровня 1В — вам он теперь наверняка еще более полезен, и вы можете освоить более продвинутые техники (если еще не освоили).</p>",
                "<p>Reread the text about testing tasks from level 1B again \u2014 it's probably even more useful to you now, and you can master more advanced techniques (if you haven't mastered them yet).</p>")),
        ], "testing_advanced"),
        count: false
    }