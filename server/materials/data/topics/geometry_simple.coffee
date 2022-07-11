import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

mainPrinciples = () ->
    page(ruen(
        "Главные правила работы с геометрией",
        "The main rules of working with geometry"), ruen(
                                                    String.raw"""<h1>Главные правила работы с геометрией</h1>
        <p>
        При работе с геометрией есть три главных правила. (Этот текст — в дополнение в основной теории в видеолекциях.)
        </p>
        <p>Во-первых, помните правила работы с вещественными числами, и главное — <b>не используйте вещественные числа, если можно обойтись без них</b>. 
        Если все входные данные у вас целочисленны (а так обычно бывает), то нередко можно все задачу полностью решить в целых числах. 
        И это намного правильнее, чем использовать вещественные числа. Иногда, конечно, бывает так, что в целых числах задачу не решить,
        например, если ответ сам по себе может быть вещественным (например, если надо найти точку пересечения двух прямых, то ее координаты могут быть нецелыми,
        даже если входные данные целочисленны).
        Но тогда постарайтесь в любом случае использовать вещественные числа только там, где они потребовались — например, прежде чем искать точку пересечения
        вы, наверное, заходите проверить, не параллельны ли две прямые, а это можно и нужно делать полностью в целых числах.
        А если уж вам приходится использовать вещественные числа, то не забывайте про <code>eps</code>.</p>

        <p>Во-вторых, <b>ваши друзья — это векторное и скалярное произведение</b>. Почти все задачи про прямые, отрезки, точки и т.д. можно решить с помощью векторных 
        и скалярных произведений, и такое решение будет работать чище и надежнее, чем любое другое. Если вы работаете с прямыми, то можете использовать представление прямой
        в виде коэффициентов A, B, C — это по сути то же векторное или скалярное произведение, только вид сбоку.</p>

        <p>В-третьих, <b>старайтесь не работать отдельно с координатами X и Y</b>. Если вы хотите рассмотреть особо случай типа <code>x==0</code>,
        или вообще вы хотите написать формулу, в которую входит только <code>x</code>, и т.п. — скорее всего, 
        вы что-то делаете не так. Скорее вам надо использовать векторное или скалярное произведение (см. правило 2), и <code>x==0</code> не будет особым случаем.
        Вообще, большинство из тех задач, которые будут в этой теме, обладают вращательной симметрией — если вы повернете всю картину на произвольный угол вокруг начала координат,
        то задача останется такой же, ответ или не изменится, или тоже повернется. Поэтому логично и в коде использовать только те величины, которые не меняются при повороте.
        Вот скалярное и векторное произведения — не меняются. А отдельные координаты — меняются. Если вы пишете условие <code>if x == 0</code>, то при повороте результат сравнения изменится.
        А если вы считаете векторное произведение и сравниваете его с нулем — результат сравнения не изменится. Намного удобнее писать код так, чтобы он не зависел от поворота.
        (Конечно, если по смыслу задачи вращательной симметрии нет, то основные аргументы тут уже не работают, и вам где-то придется писать несимметричный код, но во многих задачах симметрия есть.)

        <p>Частным случаем п. 3 является то, что не надо использовать представление прямой в виде <code>y=k*x+b</code>. 
        Мало того, что оно не симметрично относительно X и Y, оно еще и не работает для вертикальных прямых. 
        Используйте представление в виде <code>A*x+B*y+C=0</code>,
        или через векторное произведение (что на самом деле то же самое, что и ABC), или параметрический способ.</p>""",
                                                    String.raw"""<h1>The main rules of working with geometry</h1>
        <p>
        There are three main rules when working with geometry. (This text is in addition to the basic theory in video lectures.)
        </p>
        <p>First, remember the rules of working with real numbers, and most importantly — do <b>not use real numbers if you can do without them</b>. 
        If all your input data is integer (as it usually happens), then it is often possible to completely solve the whole problem in integers. 
        And this is much more correct than using real numbers. Sometimes, of course, it happens that the problem cannot be solved in integers,
        for example, if the answer itself can be real (for example, if you need to find the intersection point of two straight lines, then its coordinates may be non-integer,
        even if the input data is integer).
        But then try in any case to use real numbers only where they are needed — for example, before looking for an intersection point
        you probably come to check if two straight lines are parallel, and this can and should be done completely in integers.
        And if you have to use real numbers, then don't forget about <code>eps</code>.</p>

        <p>Secondly, <b>your friends are a vector and scalar product</b>. Almost all problems about lines, segments, points, etc. can be solved using vector 
        and scalar products, and such a solution will work cleaner and more reliable than any other. If you work with straight lines, you can use the straight line representation
        in the form of coefficients A, B, C is essentially the same vector or scalar product, only side view.</p>

        <p>Third, <b>try not to work separately with the X and Y coordinates</b>. If you want to consider especially the case of type <code>x==0</code>,
        or in general you want to write a formula that includes only <code>x</code>, etc. — most likely,
you are doing something wrong. Rather, you need to use a vector or scalar product (see rule 2), and <code>x==0</code> will not be a special case.
        In general, most of the tasks that will be in this topic have rotational symmetry — if you rotate the whole picture at an arbitrary angle around the origin,
        then the task will remain the same, the answer will either not change, or it will also turn. Therefore, it is logical to use only those values in the code that do not change during rotation.
        Here the scalar and vector products do not change. And individual coordinates change. If you write the condition <code>if x == 0</code>, then when you rotate the comparison result will change.
        And if you count a vector product and compare it with zero, the result of the comparison will not change. It is much more convenient to write code so that it does not depend on rotation.
        (Of course, if there is no rotational symmetry in the meaning of the problem, then the main arguments no longer work here, and you will have to write asymmetric code somewhere, but there is symmetry in many problems.)

        <p>A special case of point 3 is that it is not necessary to use the representation of a straight line in the form <code>y=k*x+b</code>. 
        Not only is it not symmetrical with respect to X and Y, it also does not work for vertical lines. 
        Use the representation as <code>A*x+B*y+C=0</code>,
        either through a vector product (which is actually the same as ABC), or a parametric way.</p>"""), {skipTree: true})

export default geometry_simple = () ->
    return {
        topic: topic(
            ruen("Простая геометрия", "Simple geometry"),
            ruen("Задачи на простую геометрию", "Problems on simple geometry"),
        [label(ruen(
             "<div>См. <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">видеозаписи лекций ЛКШ.2013.B'</a>, раздел \"Вычислительная геометрия\".<br>\nСм. <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ.2008.B'</a>, раздел \"Вычислительная геометрия\".</div>",
             "<div>See the video <a href=\"https://sis.khashaev.ru/2013/july/b-prime/\">recordings of lectures of LKSH.2013.B'</a>, section \"Computational Geometry\".<br>\nSee the video <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">recordings of lectures of LKSH.2008.B'</a>, section \"Computational Geometry\".</div>")),
            mainPrinciples(),
            problem(269),
            problem(275),
            problem(436),
            problem(447),
            problem(448),
            problem(1353),
            problem(279),
            problem(280),
            problem(433),
        ], "geometry_simple"),
        advancedProblems: [
            problem(1350),
            problem(435),
            problem(2806),
            problem(1349),
            problem(3870),
            problem(493),
            problem(441),
            problem(3099),
        ]
    }
