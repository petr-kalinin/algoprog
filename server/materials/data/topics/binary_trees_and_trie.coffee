import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default binary_trees_and_trie = () ->
    return {
        topic: topic("Бинарные деревья и бор", "Задачи на бинарные деревья и бор", [
            label("Теории тут пока нет"),
            problem(757),
            problem(760),
            problem(761),
            problem(111730),
            problem(3302),
            problem(111729),
        ], "trees_and_trie"),
        advancedProblems: [
            problem(30),
            problem(1044),
        ]
    }