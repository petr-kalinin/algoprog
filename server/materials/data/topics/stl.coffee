import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"


export default stl = () ->
    return {
        topic: topic(
            ruen("*Стандартные структуры данных (STL и т.п.) ", "*Standard data structures (STL, etc.) "),
            ruen("*Задачи на стандартные структуры данных", "*Problems on standard data structures"),
        [label(ruen("""<p>Тема не обязательная, но будет полезна в дальнейшем. Задачи этой темы можно решать с помощью теории с высоких уровней, но в C++ есть полезные стандартные структуры,
            которые вам позволят эти задачи решать легче. Возможно, задачи вам все равно покажутся сложными — но тема не обязательная, можете возвращаться к ним потом.</p>
            <p>Теория по C++: <a href='https://inf.1sept.ru/view_article.php?ID=200800106'>раз</a>, <a href='https://codeforces.com/blog/entry/9702'>два</a>, <a href='https://tproger.ru/articles/stl-cpp/'>три</a>. 
            Вам не надо все учить наизусть, просто надо понимать, что бывает.</p>
            <p>В других языках напрямую таких же структур нет, но можете поискать что-нибудь похожее. В Java скорее всего найдете, в питоне только для части задач, в паскале ничего такого по сути нет.</p>""",
            """<p>The topic is optional, but it will be useful in the future. The problems of this topic can be solved using theory from high levels, but there are useful standard structures in C++,
            which will allow you to solve these tasks easier. Perhaps the tasks will still seem difficult to you — but the topic is not mandatory, you can return to them later.</p>
            <p>You mostly need to know the following C++ templates: <code>std::vector</code>, <code>std::set</code>, <code>std::map</code>, optionally their <code>unordered</code> variants and <code>std::list</code> and <code>std::queue</code>. And <code>std::sort</code> function. You can read about them in your favorite reference book, or use some links that I found: <a href='https://www.geeksforgeeks.org/the-c-standard-template-library-stl/'>one</a>, <a href='https://abhiarrathore.medium.com/the-magic-of-c-stl-standard-template-library-e910f43379ea'>two</a>.
            You don't have to learn everything by heart, you just need to understand what happens.</p>
            <p>There are no such structures directly in other languages, but you can look for something similar. In Java, you will most likely find it, in python only for part of the tasks, in pascal there is nothing like that in fact.</p>""")),
            problem(112536),
            problem(2782),
            problem(111771),
            problem(3492)
        ], "stl"),
        advancedProblems: [
            problem(112984),
        ]
        count: false
    }