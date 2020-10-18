import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default testing_advanced = () ->
    return {
        topic: topic("Продвинутое тестирование задач", null, [
            label("<p>Перечитайте еще раз текст про тестирование задач из уровня 1В — вам он теперь наверняка еще более полезен, и вы можете освоить более продвинутые техники (если еще не освоили).</p>"),
        ], "testing_advanced"),
        count: false
    }