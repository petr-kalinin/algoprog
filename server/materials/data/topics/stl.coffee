import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"


export default stl = () ->
    return {
        topic: topic("*Стандартные структуры данных (STL и т.п.) ", "*Задачи на стандартные структуры данных", [
            label("""<p>Тема не обязательная, но будет полезна в дальнейшем. Задачи этой темы можно решать с помощью теории с высоких уровней, но в C++ есть полезные стандартные структуры,
            которые вам позволят эти задачи решать легче. Возможно, задачи вам все равно покажутся сложными — но тема не обязательная, можете возвращаться к ним потом.</p>
            <p>Теория по C++: <a href='https://inf.1sept.ru/view_article.php?ID=200800106'>раз</a>, <a href='https://codeforces.com/blog/entry/9702'>два</a>, <a href='https://tproger.ru/articles/stl-cpp/'>три</a>. 
            Вам не надо все учить наизусть, просто надо понимать, что бывает.</p>
            <p>В других языках напрямую таких же структур нет, но можете поискать что-нибудь похожее. В Java скорее всего найдете, в питоне только для части задач, в паскале ничего такого по сути нет.</p>"""),
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