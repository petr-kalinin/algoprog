import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default simple_games = () ->
    return {
        topic: topic(
            ruen("Простые игры на графах", "Simple graph games"),
            ruen("Задачи на простые игры на графах", "Problems on simple graph games"),
        [label(ruen(
             "<a href=\"https://e-maxx.ru/algo/games_on_graphs\">Некоторая теория на e-maxx</a>",
             "<a href=\"https://e-maxx.ru/algo/games_on_graphs\">Some theory on e-maxx</a>")),
            problem(202),
            problem(366),
            problem(3344),
            problem(371),
        ], "games_simple"),
        advancedProblems: [
            problem(112448),
            problem(112445),
        ]
    }