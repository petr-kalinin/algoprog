import label from "../../lib/label"
import topic from "../../lib/topic"

export default debugging = () ->
    return {
        topic: topic("Как отлаживать программы", null, [
            label("<a href=\"https://blog.algoprog.ru/how-to-debug-small-programs/\">Про то, как искать ошибки в маленьких программах</a>. Вы, наверное, пока еще не все тут поймете, но тем не менее прочитайте, а потом возвращайтесь к этому тексту на всем протяжении уровня 1."),
        ], "debugging"),
        count: false
    }
