import contest from "../../lib/contest"
import label from "../../lib/label"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module25226 = () ->
    page(ruen(
        "Про жадные алгоритмы",
        "About greedy algorithms"), ruen(
                                     String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>"Жадные" алгоритмы</h2>
        <p>Жадные алгоритмы — это алгоритмы, которые, на каждом шагу принимают локально оптимальное решение, не заботясь о том, что будет дальше. Они не всегда верны, но есть задачи, где жадные алгоритмы работают правильно.</p>
        
        <p>Пример жадного алгоритма следующий. Вспомните <a href="/material/p915" onclick="window.goto('/material/p915')();return false;">задачу "Платная лестница"</a> из контеста на ДП. Правильное решение в этой задаче — это именно динамика, но в этой задаче можно также придумать и следующее жадное решение (правда, неправильное). На каждом шагу у нас есть два варианта — подняться на следующую ступеньку или перепрыгнуть через ступеньку. Вот посмотрим, какой из этих двух вариантов дешевле, т.е. на какой из этих ступенек меньше цена, и сделаем такой шаг.</p>
        
        <p>Конечно, это решение неправильное, вот пример. Если на ступеньках написаны следующие числа:</p>
        <pre>1 2 10 2
        </pre>
        <p>то жадный алгоритм увидит, что изначально у него есть два варианта: сходить на ступеньку с числом 1 или с числом 2 — и пойдет на ступеньку с числом 1, т.к. это дешевле. Но правильное решение здесь — пойти на ступеньку с числом 2, т.к. потом мы сможешь перепрыгнуть ступеньку с числом 10.</p>
        
        <p>Этот пример четко показывает, почему жадные алгоритмы обычно не работают. Они не учитывают далекие последствия своих действий, они делают выбор, который оптимален только с учетом ближайших перспектив.</p>
        
        <p>(Сразу отмечу, что нередко жадные алгоритмы хочется применить в задачах на ДП. Да, многие задачи на жадность и на ДП похожи, просто в жадном алгоритме вы доказываете, что вариантов рассматривать не надо, а в ДП вы их честно рассматриваете. Поэтому если жадность не работает, то подумайте, не получится ли тут придумать ДП. Но на самом деле есть и много задач на жадность, где ДП не особенно придумаешь, и много задач на жадность, которые вообще не похожи на ДП.)</p>
        
        <p>Но бывают задачи, в которых жадность все-таки работает, в которых можно <i>доказать</i>, что жадный алгоритм корректен. На самом деле, в наиболее простых задачах корректность жадности очевидна (и на этом уровне у вас в основном будут именно задачи такого типа, более продвинутые будут на уровне 6Б), еще в некоторых задачах корректность жадности может быть не очевидна (или даже может быть несколько разных жадных алгоритмов, которые можно придумать, и непонятно, какой из них правильный), но вы можете написать жадность, отправить на проверку (если это возможно на конкретной олимпиаде) и сразу узнать, корректна она или нет. Наконец, даже если жадность некорректна, она нередко работает в простых случаях, поэтому жадные алгоритмы нередко неплохо подходят на роль частичных решений.</p>
        
        <h3>Как доказывать жадность?</h3>
        
        <p>Как обычно доказывают жадные алгоритмы? На самом деле, на текущем уровне вам не обязательно научиться их доказывать, но если поймете, что написано ниже, то будет хорошо.</p>
        
        <p>Есть два подхода к доказательству задач на жадность. Первый вариант более общий. Он может быть применен в тех задачах, где вам надо сделать несколько последовательных шагов, несколько последовательных выборов. (В примере задачи про платную лестницу выше — вы именно делаете несколько последовательных выборов "на какую ступеньку сходить".) Вам надо доказать, что если вы сделаете локально оптимальный выбор, то он не отменит возможность придти к глобально оптимальному решению. Обычно доказательство идет так: возьмем решение, построенное жадным алгоритмом, возьмем оптимальное решение, найдем первый шаг, где они отличаются, и докажем, что оптимальное решение можно поменять так, чтобы оно осталось оптимальным, но этот отличающийся шаг стал совпадать с жадным решением. Тогда мы имеем оптимальное решение, которое совпадает с жадным на один шаг дальше. Тогда очевидно, что есть оптимальное решение, которое полностью совпадает с жадным, т.е. что жадное является оптимальным.</p>
        
        
        <p>Пример. Пусть у нас задача: есть $N$ вещей, каждая со своим весом. Надо выбрать как можно больше вещей так, чтобы суммарный вес не превосходил заданного числа $C$. Очевидное жадное решение: брать вещи, начиная с самой легкой, пока суммарный вес не превосходит $C$. Как только превзошел — все, выводим ответ.</p>
        
        <p>Давайте докажем. Рассмотрим жадное решение, оно берет себе вещи в порядке возрастания веса. Рассмотрим оптимальное решение и рассмотрим первый шаг, когда в жадном решении мы отклонились от оптимального. Это значит, что в жадном решении мы взяли вещь (пусть это вещь $X$), которая не входит в оптимальное решение. Значит, в оптимальном решении должна быть какая-то вещь (пусть это вещь $Y$), которой нет в жадном, иначе в жадном решении было бы больше вещей, чем в оптимальном, что противоречит оптимальности. При этом вещь $Y$ не легче, чем вещь $X$, т.к. в жадном решении мы брали все вещи в порядке возрастания веса. Тогда возьмем оптимальное решение, и заменим в нем вещь $Y$ на вещь $X$. Суммарный вес вещей в оптимальном решении не увеличится, количество вещей не уменьшится, поэтому решение по-прежнему будет оптимальным. Но оно будет совпадать с жадным на шаг дальше. ЧТД.</p>
        
        <p>Второй вариант доказательства подходит к тем задачам, где вам надо выбрать некоторый <i>порядок</i> предметов: набор предметов вам задан, а надо выбрать, в каком порядке их расположить, чтобы что-то оптимизировать. Тогда вы можете попробовать доказать, что предметы надо расположить в порядке возрастания некоторого параметра (это и будет жадным алгоритмом). Доказательство будет таким: пусть в оптимальном решении предметы идут не в таком порядке. Тогда найдем два соседних предмета, которые идут в неправильном порядке, и поменяем их местами, и докажем, что решение не ухудшится, а значит, останется оптимальным. Тогда очевидно, что жадное решение (которое расставляет предметы в порядке возрастания этого параметра) будет корректным.</p>
        
        <p>Пример. В олимпиадах типа ACM участники решают задачи. За каждую решенную задачу они получают штраф, равный времени, прошедшему с начала тура до момента решения этой задачи. Предположим, что у нас есть идеальная команда, и она тратит $t_i$ минут на решение $i$-й задачи (и никогда не делает неудачных попыток). В каком порядке им надо решать задачи, чтобы получить минимальный штраф?</p>
        
        <p>Жадный алгоритм: в порядке возрастания $t_i$. Доказательство. Пусть у нас есть оптимальное решение, в котором $t_i$ не отсортированы по возрастанию. Найдем две задачи, $i$ и $j$, такие, что в оптимальном решении мы решаем сначала решаем задачу $i$, а сразу после нее задачу $j$, при этом $t_i&gt;=t_j$. Поменяем их местами. Что изменится в плане штрафного времени? Для всех задач, которые мы решали до этих двух, штрафное время не изменится. Для всех задач, которые мы решали после этих двух, штрафное время тоже не изменится. (Именно для этого мы и брали соседние задачи.) Штрафное же время по этим задачам было $t_i+(t_i+t_j)$, а стало $t_j+(t_i+t_j)$. Поскольку $t_i&gt;=t_j$, то решение не ухудшилось, значит, оно осталось оптимальным. ЧТД.</p>
        
        <p>(Оба доказательства выше в принципе можно переформулировать на доказательства от противного: что если оптимальное решение сильно отличается от жадного, то мы меняем оптимальное решение, получаем решение, которое строго лучше, значит, оптимальное решение было не оптимальным. Да, так доказывать тоже можно, но надо аккуратно обойтись со случаем равных значений — случаем $t_i=t_j$ или случаем двух вещей одного веса в первой задаче.)</p>
        
        <p>На самом деле, второй вариант доказательства на самом деле позволяет <i>придумывать</i> жадность в тех задачах, где она не очевидна (если не поймете этот абзац, то не страшно). Если вам в задаче надо расположить объекты в некотором порядке, и вы не знаете, в каком, подумайте: пусть у вас есть некоторый порядок. Поменяем местами два соседних предмета, посмотрим, как изменится решение. Пусть оценка старого решения была $X$, а нового — $Y$ (это, конечно, функция решения). Напишем условие $X&gt;Y$, т.е. что решение улучшилось. Попробуем его преобразовать так, чтобы свести все к характеристикам двух объектов, которые мы меняем местами. Тогда, может быть, мы обнаружим, что условие $X&gt;Y$ эквивалентно условию $f(i)&gt;f(j)$, где $i$ и $j$ — предметы, которые мы поменяли местами, а $f$ — какая-то функция. Тогда очевидно, что в правильном решении надо просто отсортировать предметы по значению функции $f$.</p></div>""",
                                     String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>"Greedy" algorithms</h2>
        <p>Greedy algorithms are algorithms that, at every step, make a locally optimal decision without worrying about what will happen next. They are not always correct, but there are tasks where greedy algorithms work correctly.</p>
        
        <p>An example of a greedy algorithm is as follows. Remember the <a href="/material/p915" onclick="window.goto('/material/p915')();return false;">"Paid Ladder" task</a> from the DP contest. The correct solution in this problem is precisely the dynamics, but in this problem you can also come up with the following greedy solution (true, wrong). At every step we have two options — to climb the next step or jump over the step. Let's see which of these two options is cheaper, i.e. which of these steps has a lower price, and we will make such a step.</p>
        
        <p>Of course, this solution is wrong, here is an example. If the following numbers are written on the steps:</p>
        <pre>1 2 10 2
        </pre>
        <p>then the greedy algorithm will see that initially it has two options: go to the step with the number 1 or with the number 2 — and go to the step with the number 1, because it is cheaper. But the right solution here is to go to the step with the number 2, because then we will be able to jump the step with the number 10.</p>
        
        <p>This example clearly shows why greedy algorithms usually don't work. They do not take into account the long-term consequences of their actions, they make a choice that is optimal only taking into account the immediate prospects.</p>
        
        <p>(I'll note right away that I often want to use greedy algorithms in DP tasks. Yes, many tasks are similar to greed and DP, it's just that in a greedy algorithm you prove that there are no options to consider, and in DP you honestly consider them. Therefore, if greed does not work, then think about whether it will be possible to come up with a DP here. But in fact, there are also many tasks for greed, where DP is not particularly imaginable, and many tasks for greed that do not look like DP at all.)</p>
        
        <p>But there are problems in which greed still works, in which it is possible to <i>prove</i> that the greedy algorithm is correct. In fact, in the simplest tasks, the correctness of greed is obvious (and at this level you will mostly have tasks of this type, more advanced ones will be at level 6B), in some tasks, the correctness of greed may not be obvious (or there may even be several different greedy algorithms that you can come up with, and it is not clear which one is correct), but you can write greed, send it for verification (if possible at a particular Olympiad) and immediately find out whether it is correct or not. Finally, even if greed is incorrect, it often works in simple cases, so greedy algorithms are often well suited for the role of partial solutions.</p>
        
        <h3>How to prove greed?</h3>
        
        <p>How do greedy algorithms usually prove? In fact, at the current level, you don't have to learn how to prove them, but if you understand what is written below, it will be good.</p>
        
        <p>There are two approaches to proving greed problems. The first option is more general. It can be applied in those tasks where you need to make several consecutive steps, several consecutive choices. (In the example of the problem about the paid ladder above, you are making several consecutive choices "which step to go to".) You need to prove that if you make a locally optimal choice, it will not cancel the opportunity to come to a globally optimal solution. Usually the proof goes like this: let's take a solution constructed by a greedy algorithm, take the optimal solution, find the first step where they differ, and prove that the optimal solution can be changed so that it remains optimal, but this different step began to coincide with the greedy solution. Then we have an optimal solution that coincides with the greedy one step further. Then it is obvious that there is an optimal solution that completely coincides with the greedy one, i.e. that the greedy one is optimal.</p>
        
        
        <p>Example. Let's say we have a problem: there are $N$ things, each with its own weight. It is necessary to choose as many things as possible so that the total weight does not exceed a given number of $C$. The obvious greedy solution is to take things, starting with the lightest, until the total weight does not exceed $C$. As soon as I surpassed — that's it, we output the answer.</p>
        
        <p>Let's prove it. Consider a greedy solution, it takes things in ascending order of weight. Let's consider the optimal solution and consider the first step when we deviated from the optimal one in the greedy solution. This means that in the greedy solution we have taken a thing (let it be a thing $X$) that is not included in the optimal solution. So, there must be some thing in the optimal solution (let it be a $Y$ thing) that is not in the greedy one, otherwise there would be more things in the greedy solution than in the optimal one, which contradicts optimality. At the same time, the thing $Y$ is not lighter than the thing $X$, because in the greedy solution we took all the things in ascending order of weight. Then let's take the optimal solution, and replace the thing $Y$ in it with the thing $X$. The total weight of things in the optimal solution will not increase, the number of things will not decrease, so the solution will still be optimal. But it will coincide with the greedy one a step further. CHTD.</p>
        
        <p>The second version of the proof is suitable for those tasks where you need to choose a certain <i>order</i> of objects: a set of objects is given to you, but you need to choose in which order to arrange them in order to optimize something. Then you can try to prove that the items should be arranged in ascending order of some parameter (this will be a greedy algorithm). The proof will be as follows: let the objects in the optimal solution not go in this order. Then we will find two adjacent items that go in the wrong order, and swap them, and prove that the solution will not worsen, which means it will remain optimal. Then it is obvious that the greedy solution (which arranges items in ascending order of this parameter) will be correct.</p>
        
        <p>Example. In ACM-type Olympiads, participants solve problems. For each solved problem, they receive a penalty equal to the time elapsed from the beginning of the tour to the moment of solving this problem. Suppose we have an ideal team, and it spends $t_i$ minutes solving the $i$th problem (and never makes unsuccessful attempts). In what order do they need to solve the tasks in order to get the minimum penalty?</p>
        
        <p>Greedy algorithm: in ascending order $t_i$. Proof. Suppose we have an optimal solution in which $t_i$ are not sorted in ascending order. Let's find two problems, $i$ and $j$, such that in the optimal solution we solve the problem $i$ first, and immediately after it the problem $j$, while $t_i&gt;=t_j$. Let's swap them. What will change in terms of penalty time? For all the tasks that we solved before these two, the penalty time will not change. For all the tasks that we solved after these two, the penalty time will not change either. (That's why we took neighboring tasks.) The penalty time for these tasks was $t_i+(t_i+t_j)$, and it became $t_j+(t_i+t_j)$. Since $t_i&gt;=t_j$, the solution has not deteriorated, so it remains optimal. CHTD.</p>
        
        <p>(Both proofs above can in principle be reformulated into proofs from the opposite: that if the optimal solution is very different from the greedy one, then we change the optimal solution, we get a solution that is strictly better, which means that the optimal solution was not optimal. Yes, it is also possible to prove this, but we must carefully deal with the case of equal values — the case of $t_i=t_j$ or the case of two things of the same weight in the first problem.)</p>
        
        <p>In fact, the second version of the proof actually allows you to <i>invent</i> greed in those tasks where it is not obvious (if you do not understand this paragraph, then it's not scary). If you need to arrange objects in some order in the task, and you don't know in which order, think: let you have some order. Let's swap two adjacent objects, see how the solution changes. Let the estimate of the old solution be $X$ and the new one be $Y$ (this is, of course, a solution function). Let's write the condition $X&gt;Y$, i.e. that the solution has improved. Let's try to transform it so as to reduce everything to the characteristics of the two objects that we are swapping. Then maybe we will find that the condition $X&gt;Y$ is equivalent to the condition $f(i)&gt;f(j)$, where $i$ and $j$ are the items that we swapped, and $f$ is some kind of function. Then it is obvious that in the right solution, you just need to sort the items by the value of the function $f$.</p></div>"""), {skipTree: true})

module25835 = () ->
    page(ruen(
        "Разбор задачи \"Путешествие\", читать только тем, кто ее решил!",
        "Analysis of the \"Journey\" task, read only if you solved it!"), ruen(
                                                                                String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><p>Задачу "Путешествие" почему-то очень многие из вас решают очень сложно. На самом деле у этой задачи есть очень простое и короткое решение.</p>
        
        <p>Давайте для начала научимся решать задачу, когда решение существует (т.е. когда ответ не -1). Представьте, что вы едете по дороге. Вы проезжаете очередную заправку. Надо ли вам тут заправляться? Ответ очевиден: если на текущем запасе бензина вы доедете до следующей заправки, то не надо, иначе надо. Этот алгоритм элементарно реализуется, для простоты даже лучше хранить не остаток бензина (он постоянно меняется), а координату, до которой мы можем доехать на текущей заправке (она меняется только при заправках), или, что эквивалентно, информацию, где мы последний раз заправлялись (координату или номер заправки).</p>
        
        <p>Слегка альтернативный подход, но по сути то же самое — т.к. мы решаем задачу, а не едем по трассе, то мы всегда можем "отмотать" время назад. Поэтому едем по трассе, если видим, что до очередной заправки у нас не хватило бензина, то "отматываем" время назад и решаем, что надо бы заправиться на предыдущей заправке.</p>
        
        <p>Для удобства реализации можно в конец массива заправок добавить заправку с координатой $N$ (т.е. с координатой пункта назначения). При любой разумной реализации вы никогда в ней заправляться не будете, зато в основном цикле вам не придется особо рассматривать последний отрезок пути.</p>
        
        <p>Осталось научиться определять, когда ответ -1. Вообще, несложно понять, что ответ -1 тогда и только тогда, когда есть две заправки подряд, расстояние между которыми больше $k$. Это можно проверить заранее, или можно по ходу основного цикла, когда мы решаем заправиться, сразу проверять, сможем ли мы доехать хотя бы до следующей заправки.</p>
        
        <p>Вот два примера решений, которые реализуют этот простой алгоритм:</p>
        
        <pre>// Автор — Саддамбек Нурланбек уулу, комментарии мои (П.К.)
        #include <iostream>
         
        using namespace std;
         
        int k, q, c, n, a[1111];
         
        int main(){
              cin &gt;&gt; n &gt;&gt; k &gt;&gt; s;
         
              // ввод данных
              for(int i = 1;i &lt;= s;++i){
                    cin &gt;&gt; a[i];
                    // сразу проверяем, есть ли решение 
                    if(a[i] -  a[i - 1] &gt; k){
                          cout &lt;&lt; -1;
                          return 0;
                    }
              }
        
              // l - номер заправки, где заправлялись последний раз
              // (всё решение, и выше тоже, предполагает, что в a[0] == 0 изначально, 
              // это на самом деле не очень хорошо)
              int l = 0;
         
              // добавляем заправку в пункте назначения
              a[++s] = n;
         
              for(int i = 1;i &lt;= s;++i){
                    // если до текущей заправки доехать не можем
                    if(a[i] - a[l] &gt; k){
                          c++;
                          // заправляемся в предыдущем пункте
                          l = i - 1;
                    }
              }
         
              cout &lt;&lt; c;
        }
        </iostream></pre>
        <hr>
        <pre># Автор — Андрей Ефремов, комментарии мои (П.К.)
        n, k = [int(i) for i in input().split()]
        s = [int(i) for i in input().split()]
        
        # добавили заправку "очень далеко"
        s.append(2000)
        
        ans = 0
        
        # now = до какой координаты можем доехать при текущем запасе бензина
        now = k
        
        i = 1
        # пока не можем доехать до финиша
        while now &lt; n:
            # если не можем доехать до следующей заправки
            if s[i + 1] &gt; now:
                # если и до текущей не можем, то решения нет
                if s[i] &gt; now:
                    print(-1)
                    break
                else:
                    # иначе надо заправиться на текущей заправке
                    ans += 1
                    now = s[i] + k
            i += 1
        # else после while в питоне работает только если из while мы вышли не по break
        else:
            print(ans)
        </pre></div>""",
                                                                                String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><p>For some reason, many of you solve the "Journey" problem very difficult. In fact, this problem has a very simple and short solution.</p>
        
        <p>Let's first learn how to solve a problem when a solution exists (i.e. when the answer is not -1). Imagine that you are driving on the road. You are passing another gas station. Do you need to refuel here? The answer is obvious: if you get to the next gas station on the current stock of gasoline, then you don't have to, otherwise you have to. This algorithm is elementary implemented, for simplicity, it is even better to store not the rest of the gasoline (it is constantly changing), but the coordinate to which we can reach at the current gas station (it changes only when refueling), or, equivalently, information about where we last refueled (the coordinate or number of the gas station).</p>
        
        <p>A slightly alternative approach, but essentially the same — since we are solving the problem, and not driving along the highway, we can always "rewind" time back. Therefore, we drive along the highway, if we see that we did not have enough gasoline before the next gas station, then we "rewind" the time back and decide that we should refuel at the previous gas station.</p>
        
        <p>For ease of implementation, you can add a gas station with the $N$ coordinate (i.e. with the destination coordinate) to the end of the array of gas stations. With any reasonable implementation, you will never refuel in it, but in the main cycle you will not have to particularly consider the last segment of the path.</p>
        
        <p>It remains to learn how to determine when the answer is -1. In general, it is not difficult to understand that the answer is -1 if and only if there are two gas stations in a row, the distance between which is greater than $k$. This can be checked in advance, or you can check immediately during the main cycle, when we decide to refuel, whether we can get to at least the next gas station.</p>
        
        <p>Here are two examples of solutions that implement this simple algorithm:</p>
        
        <pre>// Author — Saddambek Nurlanbek uulu, my comments (P.K.)
#include <iostream>
         
        using namespace std;
         
        int k, q, c, n, a[1111];
         
        int main(){
              cin &gt;&gt; n &gt;&gt; k &gt;&gt; s;
         
              // data entry
              for(int i = 1;i &lt;= s;++i){
                    cin &gt;&gt; a[i];
                    // immediately check if there is a solution 
                    if(a[i] -  a[i - 1] &gt; k){
                          cout &lt;&lt; -1;
                          return 0;
                    }
              }
        
              // l - the number of the gas station where they refueled last time
              // (the whole solution, and above too, assumes that in a[0] == 0 initially,
// this is actually not very good)
              int l = 0;
         
              // adding refueling at the destination
              a[++s] = n;
         
              for(int i = 1;i &lt;= s;++i){
// if we can't get to the current gas station
                    if(a[i] - a[l] &gt; k){
                          c++;
                          // refueling in the previous paragraph
l = i - 1;
                    }
              }
         
              cout &lt;&lt; c;
        }
        </iostream></pre>
        <hr>
        <pre># Author — Andrey Efremov, my comments (P.K.)
n, k = [int(i) for i in input().split()]
s = [int(i) for i in input().split()]
        
        # added a gas station "very far away"
        s.append(2000)
        
        ans = 0
        
        # now = what coordinates can we get to with the current supply of gasoline
        now = k
        
        i = 1
        # we can't get to the finish line yet
        while now &lt; n:
            # if we can't get to the next gas station
            if s[i + 1] &gt; now:
                # if we can't get to the current one, then there is no solution
                if s[i] &gt; now:
                    print(-1)
                    break
                else:
# otherwise, you need to refuel at the current gas station
                    ans += 1
                    now = s[i] + k
            i += 1
        # else after while in python works only if we didn't exit from while by break
        else:
            print(ans)
        </pre></div>"""), {skipTree: true})

export default arrays = () ->
    return {
        topics: [
            topic(
                ruen("Простая жадность", "Simple greedy algorithms"),
                ruen("Задачи на простую жадность", "Problems on simple greed"),
            [module25226(),
                problem(1576),
                problem(2826),
                problem(113075),
                problem(734),
                problem(1130),
                problem({testSystem: "codeforces", contest: "777", problem: "B"}),
            ], "greedy_simple"),
            module25835()
        ],
        advancedProblems: [
            problem(3678),
            problem({testSystem: "codeforces", contest: "777", problem: "D"}),
        ]
    }
