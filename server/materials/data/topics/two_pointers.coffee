import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module16344 = () ->
    page(ruen(
        "Краткая теория про два указателя",
        "A brief theory about two pointers"), ruen(
                                                 String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Краткая теория про два указателя</h1>
        <p>К сожалению, я не нашел толкового описания метода двух указателей, поэтому напишу свой краткий текст.</p>
        <h2>Пример</h2>
        <p>Два указателя — это довольно простая идея, которая нередко встречается в задачах. Давайте сначала рассмотрим пример.</p>
        <p>Итак, пусть у нас задача: дан массив из $N$ положительных чисел, надо найти в нем несколько чисел, идущих подряд, так, чтобы их сумма была больше $K$, а чисел в нем содержалось бы как можно меньше.</p>
        <p>Первая, довольно понятная идея: пусть мы зафиксировали позицию (номер в массиве) $i$ первого из искомых чисел. Тогда нам надо найти ближайшую к нему справа позицию $j$ такую, что сумма чисел на позициях с $i$ по $j$ больше $K$. Это можно сделать достаточно просто циклом по $j$ от $i$ до $N$, тогда алгоритм решения всей задачи (с учетом перебора $i$) получается следующим:
        </p><pre>for i:=1 to n do begin
            s:=0;
            for j:=i to n do begin
                s:=s+a[j]; // в переменной s подсчитываем текущую сумму
                if s&gt;k then begin
                    // writeln(j); // этот вывод пригодится дальше
                    if j-i+1&lt;min then min:=j-i+1;
                    break;
                end;
            end;
        end;
        </pre>
        <p>Он работает за $O(N^2)$. Придумаем, как его можно ускорить до $O(N)$.</p>
        <p>Ключевая идея здесь следующая: если при каком-то $i=i_0$ мы в цикле по $j$ дошли до некоторого значения $j=j_0$, то при следующем $i=i_0+1$ найденное значение $j$ будет обязательно <i>не меньше</i> $j_0$. Говоря по-другому, если мы раскомментируем <code>writeln</code> в приведенном выше коде, то выводимые значения $j$ образуют неубывающую последовательность.</p>
        <p>Действительно, если при некотором $i=i_0$ мы пропустили все $j$ до $j_0$, то это значит, что сумма чисел начиная от $i_0$ до всех промежуточных $j$ была $\leq K$. Но тогда если мы начнем считать сумму чисел начиная с позиции $i_0+1$, то для всех тех же промежуточных $j$ сумма чисел уж точно будет $\leq K$ (т.к. по условию все числа положительны).</p>
        <p>А это обозначает, что нам не надо каждый раз заново запускать поиск $j$ начиная от $i$! Мы можем каждый раз начинать поиск $j$ с того значения, на котором остановились в прошлый раз:</p>
        <pre>s:=0;
        for i:=1 to n do begin
            for j:=j to n do begin // цикл начинается с j!
                s:=s+a[j]; 
                if s&gt;k then begin
                    if j-i+1&lt;min then min:=j-i+1;
                    s:=s-a[j]; // это грубый костыль, потому что на следующей итерации
                               // мы будем делать опять s:=s+a[j] с тем же j.
                               // ниже будет видно, как это сделать красивее.
                    break;
                end;
            end;
            s:=s-a[i]; // чтобы не вычислять s каждый раз заново
        end;
        </pre>
        Этот же код можно переписать несколько по-другому, может быть, проще:
        <pre>j:=1;
        s:=0;
        for i:=1 to n do begin
            while (j&lt;n)and(s&lt;=k) do begin // мы таким образом начинаем со старого значения j
                s:=s+a[j];
                inc(j);
            end;
            if s&gt;k then begin
                // +1 пропало, потому что теперь j указывает на первый невзятый элемент.
                if j-i&lt;min then min:=j-i;
            end else // если мы попали сюда, то j=n, но s&lt;=k - дальше искать нечего
                break;
            s:=s-a[i]; // перед началом следующей итерации выкинем число i
        end;
        </pre>
        <p>Это решение работает за $O(N)$. Действительно, обе переменных цикла — и $i$, и $j$ — все время работы программы <i>только увеличиваются</i>. Общее количество итераций внутреннего цикла будет равно общему количеству увеличений $j$, а это равно $N$. Все, кроме внутреннего цикла, тоже работает за $O(N)$, получаем и общую сложность $O(N)$.</p><p>
        </p><p>Переменные $i$ и $j$ в даннном контексте часто называют <i>указателями</i> — конечно, не в том смысле, что они имеют тип <code>pointer</code> (что неверно), а просто в том смысле, что они указывают на определенные позиции в массиве. Поэтому и метод этот называется методом двух указателей.</p>
        <h2>Общая идея</h2>
        <p>На этом примере очень хорошо видна суть метода двух указателей: мы пользуемся тем, что при увеличении значения одного указателя значение другого указателя тоже может только увеличиваться. Если мы перебираем $i$ в порядке возрастания, то $j$ тоже будет только возрастать — поэтому не надо перебирать каждый раз заново, можно просто продолжать с предыдущего значения.</p>
        <p>Конечно, это так не в каждой задаче, но есть задачи, где это можно доказать и это работает.</p>
        
        <h2>Еще примеры:</h2>
        <ul>
        <li>На прямой находятся $N$ точек; требуется подсчитать количество пар точек, расстояние между которыми $\geq D$. Решение: сортируем точки по координате (если они не отсортированы во входных данных). Идем одним указателем $i$ от 1 до $N$, второй указатель $j$ меняем так, чтобы среди точек, лежащих "правее" $i$ (т.е. с бОльшими номерами) он указывал на самую "левую" точку такую, что расстояние от точки $i$ до точки $j$ было $\geq D$. На каждом шагу добавляем к ответу $N-j+1$ — это общее количество точек, лежащих правее $i$ на расстоянии как минимум $D$ от нее. Поскольку при увеличении $i$ значение $j$ тоже может только увеличиваться, то метод двух указателей сработает.</li>
        <li>Даны два отсортированных массива, надо проверить, есть ли среди них одинаковые числа. Решение: запускаем два указателя, первый ($i$) бежит по одном массиву ($a$), второй ($j$) по другому ($b$) так, чтобы $b[j]$ всегда было первым элементом, большим или равным $a[i]$.</li>
        <li>На окружности заданы $N$ точек, надо найти пару точек, расстояние между которыми (по хорде окружности) максимально. Решение: сортируем точки так, чтобы они шли в порядке обхода окружности, пусть против часовой стрелки. Берем первую точку ($i=1$) и находим максимально удаленнную от нее, пусть это будет точка $j$. Далее переходим к следующей точке против часовой стрелки ($i=2$). Несложно видеть, что самая удаленная от нее точка тоже сдвинется против часовой стрелки (ну или останется на месте), т.е. $j$ только увеличится. И так далее; надо только учесть, что окружность зациклена и после $N$-й точки идет первая. В итоге в решении оба указателя совершат полный оборот по окружности.</li>
        <li>На окружности заданы $N$ точек, надо найти три точки такие, что площадь натянутого на них треугольника максимальна. Решение за $O(N^2$): сортируем точки так же. Зафиксируем первую вершину треугольника. Запустим два указателя для второй и третьей вершин треугольника: при сдвиге второй вершины треугольника против часовой стрелки третья тоже двигается против часовой стрелки. Так за $O(N)$ найдем треугольник максимальной площади при фиксированной первой вершине. Перебрав все первые вершины, за $O(N^2)$ решим задачу.</li>
        </ul>
        
        <h2>Альтернативные реализации</h2>
        <p>Выше у нас всегда один указатель был "главным", а другой "ведомым". Нередко программу можно написать и так, что оба указателя будут равноправными. Ключевая идея — на каждом шагу смотрим на текущую "ситуацию" и в зависимости от нее двигаем один из двух указателей.</p>
        <p>Например, в нашем примере про сумму на подотрезке больше $K$:</p>
        <pre>i:=1;
        j:=1;
        s:=a[1];
        while j&lt;=n do begin
            if s&gt;k then begin
                        // если s&gt;k, то надо, во-первых, проверить решение,
                        // а во-вторых, точно можно двигать первый указатель
                if j-i+1&lt;min then min:=j-i+1;
                s:=s-a[i]; // не забываем корректировать сумму
                inc(i);
            end else begin // а иначе надо двигать второй указатель
                inc(j);
                s:=s+a[j];
            end;
        end;
        </pre>
        <p>Еще проще — в задаче поиска двух одинаковых элементов в двух отсортированных массивах (считаем, что массивы отсортированы по возрастанию):</p>
        <pre>while (i&lt;=n)and(j&lt;=m) do begin
            if a[i]=b[j] then begin
                writeln(i,' ',j);
                break;
            end else if a[i]&gt;b[j] then inc(j)
            else inc(i);
        end;
        </pre>
        
        <h2>Два указателя и бинпоиск</h2>
        <p>Многие задачи, решаемые двумя указателями, можно решить и бинпоиском ценой дополнительного $\log N$ в сложности решения. Например, в нашем основном примере можно было бы не двигать второй указатель, а каждый раз его находить заново бинпоиском — правда, пришлось бы заранее посчитать префиксные суммы (т.е. для каждого $k$ вычислить $s[k]$ — сумму первых $k$ элементов массива); после этого сумма на отрезке от $i$ до $j$ вычисляется как разность $s[j]-s[i-1]$.</p>
        <p>Аналогично, в задаче поиска двух одинаковых элементов в двух массивах тоже можно написать бинпоиск для поиска нужного $j$.</p>
        <p>Но задачу про две наиболее удаленные точки на окружности бинпоиском не очень решишь (хотя можно там сделать тернарный поиск).</p>
        
        <h2>Два указателя и сортировка событий или сканлайн</h2>
        <p>В дальнейшем вы узнаете про метод сортировки событий, он же сканлайн. Сейчас я пока только скажу, что он имеет много общего с методом двух указателей. А именно, многие задачи на два указателя также решаются и сортировкой событий, или сканлайном. Например, в задаче поиска количества точек на прямой таких, что расстояние между ними $\geq d$, можно было бы взять все данные нам точки, добавить еще раз эти же точки, но сдвинутые вправо на $d$, отсортировать все в одном массиве, сохраняя тип точки (сдвинутая или нет) и потом один раз пробежаться по этому массиву.</p>
        <p>Аналогично, задачу про поиск двух одинаковых чисел в двух массивах можно решить просто слиянием этих двух массивов в один, что тоже можно рассматривать как вариант сканлайна или сортировки событий.</p>
        
        <h2>Много указателей</h2>
        <p>Бывают задачи, когда вам нужны много указателей. Если вы можете организовать алгоритм так, что все ваши $M$ указателей только увеличивают свои значения, то алгоритм будет работать за $O(NM)$. Как-то примерно так:</p>
        <pre>while все указатели не дошли до конца do begin
           if можно увеличить первый указатель then увеличить первый указатель
           else if можно увеличить второй указатель then увеличить второй указатель
           else ...
        end;
        </pre>
        </div>""",
                                                 String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>A brief theory about two pointers</h1>
        <p>Unfortunately, I have not found a sensible description of the two-pointer method, so I will write my short text.</p>
        <h2>Example</h2>
        <p>Two pointers is a fairly simple idea that is often found in problems. Let's look at an example first.</p>
        <p>So, let's say we have a problem: given an array of $N$ positive numbers, we need to find in it several numbers running in a row, so that their sum is greater than $K$, and the numbers in it would contain as few as possible.</p>
        <p>The first, rather clear idea: let us fix the position (number in the array) $i$ of the first of the required numbers. Then we need to find the position $j$ closest to it on the right such that the sum of the numbers in positions from $i$ to $j$ is greater than $K$. This can be done quite simply by a $j$ cycle from $i$ to $N$, then the algorithm for solving the entire problem (taking into account the $i$ iteration) turns out as follows:        
        </p><pre>for i:=1 to n do begin
            s:=0;
            for j:=i to n do begin
                s:=s+a[j]; // in the variable s we calculate the current amount
                if s&gt;k then begin
                    // writeln(j); // this print will come in handy later
                    if j-i+1&lt;min then min:=j-i+1;
                    break;
                end;
            end;
        end;
        </pre>
        <p>It works for $O(N^2)$. Let's figure out how it can be accelerated to $O(N)$.</p>
        <p>The key idea here is as follows: if for some $i=i_0$ we reached a certain value of $j=j_0$ in a $j$ loop, then for the next $i=i_0+1$, the found value of $j$ will necessarily be <i>no less</i> $j_0$. To put it another way, if we uncomment <code>writeln</code> in the above code, then the output values of $j$ form a non-decreasing sequence.</p>
        <p>Indeed, if for some $i=i_0$ we skipped all $j$ to $j_0$, then it means that the sum of the numbers starting from $i_0$ to all intermediate $j$ was $\leq K$. But then if we start counting the sum of the numbers starting from the position $i_0+1$, then for all the same intermediate $j$ the sum of the numbers will certainly be $\leq K$ (because by condition all numbers are positive).</p>
        <p>And this means that we don't have to restart the search for $j$ every time starting from $i$! We can start searching for $j$ every time from the value we stopped at last time:</p>
        <pre>s:=0;
        for i:=1 to n do begin
            for j:=j to n do begin // the cycle starts with j!
                s:=s+a[j]; 
                if s&gt;k then begin
                    if j-i+1&lt;min then min:=j-i+1;
                    s:=s-a[j]; // this is a dirty hack, because in the next iteration 
                               // we will do s again:=s+a[j] with the same j. 
                               // Below you will see how to make it more beautiful.
                    break;
                end;
            end;
            s:=s-a[i]; // in order not to calculate s every time again
        end;
        </pre>
        The same code can be rewritten in a slightly different way, maybe easier:
        <pre>j:=1;
        s:=0;
        for i:=1 to n do begin
            while (j&lt;n)and(s&lt;=k) do begin // we thus start with the old value of j
                s:=s+a[j];
                inc(j);
            end;
            if s&gt;k then begin
                // +1 is missing because now j points to the first unused element.
                if j-i&lt;min then min:=j-i;
            end else // if we got here, then j =n, but s&lt;=k - there is nothing further to look for
                break;
            s:=s-a[i]; // before starting the next iteration, we will throw out the number i
        end;
        </pre>
        <p>This solution works for $O(N)$. Indeed, both loop variables — both $i$ and $j$ — are only increasing </i> all the time the program is running. The total number of iterations of the inner loop will be equal to the total number of increments of $j$, and this is equal to $N$. Everything except the inner loop also works for $O(N)$, and we get the total complexity of $O(N)$.</p><p>
        </p><p>Variables $i$ and $j$ in this context are often called <i>pointers</i> — of course, not in the sense that they are of type <code>pointer</code> (which is incorrect), but simply in the sense that they point to certain positions in the array. Therefore, this method is called the two-pointer method.</p>
        <h2>General idea</h2>
        <p>In this example, the essence of the two-pointer method is very clearly visible: we take advantage of the fact that when the value of one pointer increases, the value of the other pointer can also only increase. If we iterate over $i$ in ascending order, then $j$ will also only increase — so we don't have to iterate over again every time, we can just continue from the previous value.</p>
        <p>Of course, this is not the case in every problem, but there are problems where it can be proved and it works.</p>

        <h2>More examples:</h2>
        <ul>
        <li>There are $N$ points on the straight line; it is required to count the number of pairs of points whose distance is $\geq D$. Solution: sort the points by coordinate (if they are not sorted in the input data). We go with one pointer $i$ from 1 to $N$, we change the second pointer $j$ so that among the points lying "to the right" of $i$ (i.e. with large numbers) it points to the "leftmost" point such that the distance from point $i$ to point $j$ was $\geq D$. At each step, we add $N-j+1$ to the answer — this is the total number of points lying to the right of $i$ at a distance of at least $D$ from it. Since with an increase in $i$, the value of $j$ can also only increase, the two-pointer method will work.</li>
        <li>Two sorted arrays are given, it is necessary to check whether there are identical numbers among them. Solution: we run two pointers, the first ($i$) runs on one array ($a$), the second ($j$) on the other ($b$) so that $b[j]$ is always the first element greater than or equal to $a[i]$.</li>
        <li>$N$ points are given on the circle, it is necessary to find a pair of points, the distance between which (along the chord of the circle) is maximum. Solution: sort the points so that they go in the order of circumventing the circle, even counterclockwise. We take the first point ($i=1$) and find the one that is as far away from it as possible, let it be the point $j$. Then go to the next point counterclockwise ($i=2$). It is easy to see that the point furthest from it will also move counterclockwise (well, or stay in place), i.e. $j$ will only increase. And so on; it is only necessary to take into account that the circle is looped and after the $N$th point comes the first one. As a result, in the solution, both pointers will make a complete revolution around the circle.</li>
        <li>There are $N$ points on the circle, we need to find three points such that the area of the triangle stretched on them is maximal. Solution for $O(N^2$): sort the points the same way. Let's fix the first vertex of the triangle. Let's run two pointers for the second and third vertices of the triangle: when the second vertex of the triangle is shifted counterclockwise, the third one also moves counterclockwise. So for $O(N)$ we will find a triangle of maximum area with a fixed first vertex. After iterating over all the first vertices, for $O(N^2)$ let's solve the problem.</li>
        </ul>

        <h2>Alternative implementations</h2>
        <p>Above, we always had one pointer as the "master" and the other as the "slave". Often, a program can be written in such a way that both pointers will be equal. The key idea is that at every step we look at the current "situation" and, depending on it, we move one of the two pointers.</p>
        <p>For example, in our example about the amount on the sub-section greater than $K$:</p>
        <pre>i:=1;
        j:=1;
        s:=a[1];
        while j&lt;=n do begin
            if s&gt;k then begin
                        // if s&gt;k, then it is necessary, first, to check the solution,
                        // and secondly, you can definitely move the first pointer
                if j-i+1&lt;min then min:=j-i+1;
                s:=s-a[i]; // do not forget to adjust the amount
                inc(i);
            end else begin // otherwise, you need to move the second pointer
                inc(j);
                s:=s+a[j];
            end;
        end;
        </pre>
        <p>Even easier — in the problem of finding two identical elements in two sorted arrays (we assume that the arrays are sorted in ascending order):</p>
        <pre>while (i&lt;=n)and(j&lt;=m) do begin
            if a[i]=b[j] then begin
                writeln(i,' ',j);
                break;
            end else if a[i]&gt;b[j] then inc(j)
            else inc(i);
        end;
        </pre>
        
        <h2>Two pointers and a bin search</h2>
        <p>Many problems solved by two pointers can also be solved by binpointing at the cost of an additional $\log N$ in the complexity of the solution. For example, in our main example, it would be possible not to move the second pointer, but to find it again every time by bin—searching — however, we would have to calculate the prefix sums in advance (i.e., for each $k$, calculate $s[k]$ - the sum of the first $k$ elements of the array); after that, the sum on the segment from $i$ to $j$ is calculated as the difference $s[j]-s[i-1]$.</p>
        Similarly, in the task of finding two identical elements in two arrays, you can also write a bin search to find the right $j$.</p>
        <p>But the problem about the two most distant points on the circle is not very easy to solve with a binposer (although you can do a ternary search there).</p>

        <h2>Two pointers and event sorting or scanline</h2>
        <p>In the future, you will learn about the event sorting method, also known as scanline. For now, I'll just say that it has a lot in common with the two-pointer method. Namely, many two-pointer tasks are also solved by sorting events, or scanline. For example, in the problem of finding the number of points on a straight line such that the distance between them is $\geq d$, we could take all the points given to us, add the same points again, but shifted to the right by $d$, sort everything in one array, preserving the type of point (shifted or not) and then run through this array once.</p>
        Similarly, the problem of finding two identical numbers in two arrays can be solved simply by merging these two arrays into one, which can also be considered as a variant of scanline or event sorting.</p>

        <h2>A lot of pointers</h2>
        <p>There are tasks when you need a lot of pointers. If you can arrange the algorithm so that all your $M$ pointers only increase their values, then the algorithm will work for $O(NM)$. Something like this:</p>
        <pre>while all pointers have not reached the end do begin
            if you can increase the first pointer then increase the first pointer
            else if you can increase the second pointer then increase the second pointer
            else ...
            end;
        </pre>
        </div>"""
        ), {skipTree: true})

export default two_pointers = () ->
    return {
        topic: topic(
            ruen("Два указателя", "Two pointers"),
            ruen("Задачи на два указателя", "Problems on two pointers"),
        [module16344(),
            problem(2827),
            problem(111975),
            problem({testSystem: "codeforces", contest: "1354", problem: "B"}),
        ], "two_pointers"),
        advancedProblems: [
            problem(111493),
            problem(111634),
            problem(581),
            problem(3878),
            problem(994),
            problem(2817),
        ]
    }
