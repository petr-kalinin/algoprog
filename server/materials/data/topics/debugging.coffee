import label from "../../lib/label"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default debugging = () ->
    return {
        topic: topic("Как отлаживать программы", null, [
            label(ruen(
                "<a href=\"https://blog.algoprog.ru/how-to-debug-small-programs/\">Про то, как искать ошибки в маленьких программах</a>. Вы, наверное, пока еще не все тут поймете, но тем не менее прочитайте, а потом возвращайтесь к этому тексту на всем протяжении уровня 1.",
                "<a href=\"https://blog.algoprog.ru/how-to-debug-small-programs/\">About how to look for errors in small programs</a>. You probably won't understand everything here yet, but read it anyway, and then come back to this text throughout level 1.")),
        ], "debugging"),
        count: false
    }
