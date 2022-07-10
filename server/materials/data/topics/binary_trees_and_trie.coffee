import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default binary_trees_and_trie = () ->
    return {
        topic: topic(
            ruen("Бинарные деревья и бор", "Binary trees and boron"),
            ruen("Задачи на бинарные деревья и бор", "Problems on binary trees and boron"),
        [label(ruen(
             "Теории тут пока нет",
             "There is no theory here yet")),
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