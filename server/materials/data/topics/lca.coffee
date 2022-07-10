import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

export default lca = () ->
    return {
        topic: topic(
            ruen("LCA", "LCA"),
            ruen("Задачи на LCA", "Problems on LCA"),
        [label(ruen(
             "<p><a href=\"https://aleks5d.github.io/blog_LCA_1.html\">Теория по LCA от Алексея Упирвицкого</a></p>\n<p>См. еще <a href=\"https://e-maxx.ru/algo/\">теорию на e-maxx (там несколько разделов)</a>.</p>",
             "<p><a href=\"https://aleks5d.github.io/blog_LCA_1.html\">LCA Theory by Alexey Upirvitsky</a></p>\n<p>See more <a href=\"https://e-maxx.ru/algo/\">theory on e-maxx (there are several sections)</a>.</p>")),
            problem(111796),
            problem(111711),
            problem(111894)
        ], "lca"),
        advancedProblems: [
            problem(724)
        ]
    }