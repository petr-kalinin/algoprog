import label from "../../lib/label"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default debugging = () ->
    return {
        topic: topic(
            ruen("Как отлаживать программы", "How to debug programs"),
            null,
        [label(ruen(
                "<a href=\"https://blog.algoprog.ru/how-to-debug-small-programs/\">Про то, как искать ошибки в маленьких программах</a>. Вы, наверное, пока еще не все тут поймете, но тем не менее прочитайте, а потом возвращайтесь к этому тексту на всем протяжении уровня 1.",
                "<a href=\"https://ericlippert.com/2014/03/05/how-to-debug-small-programs/\">How to debug small programs</a>. This is a rather famous text, although I find it way too complex. Anyway, read it and you may find it useful, and one day I will add my own vision of this topic here."
        )),
                # TODO: en
                #"<a href=\"https://blog.algoprog.ru/how-to-debug-small-programs/\">About how to look for errors in small programs</a>. You probably won't understand everything here yet, but read it anyway, and then come back to this text throughout level 1.")),
        ], "debugging"),
        count: false
    }
