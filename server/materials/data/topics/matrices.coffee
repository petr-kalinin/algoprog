import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default matrices = () ->
    return {
        topic: topic("Матрицы и их применение к ДП", "Задачи на матрицы", [
            label("<p>См.\n<a href=\"https://e-maxx.ru/algo/linear_systems_gauss\">теорию по методу Гаусса на e-maxx</a>. Теории по применению матриц к ДП в удобоваримом виде я не нашел.\n</p>"),
            problem(76),
        ], "matrices")
    }