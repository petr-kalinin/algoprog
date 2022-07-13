import contest from "../../lib/contest"
import label from "../../lib/label"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module16475 = () ->
    page(ruen(
        "Теория по логарифмическим сортировкам",
        "Theory on logarithmic sorting"), ruen(
                                                      String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>Логарифмические сортировки</h2>
        <p>Логарифмические сортировки — это алгоритмы сортировки, имеющие сложность $O(N \log N)$ и использующие только сравнения элементов. Они позволяют за одну секунду отсортировать массив длиной 100&nbsp;000 — 1000&nbsp;000. Именно их вам и стоит использовать в большинстве задач, требующих сортировки.</p>
        
        <p>Существует огромное множество разных логарифмических сортировок, но реально широко используются три:</p>
        <ul>
        <li>Быстрая сортировка, она же QuickSort, сортировка Хоара, быстрая сортировка Хоара или просто qsort;</li>
        <li>Сортировка слиянием (MergeSort);</li>
        <li>Сортировка кучей (иногда говорят «пирамидой»), она же хипсорт (heapsort).</li>
        </ul>
        <p>В этом тексте я опишу сортировку слиянием и быструю сортировку. Сортировка кучей будет в теме про кучу в уровне 5А.</p>
        
        <h3>Быстрая сортировка Хоара (QuickSort)</h3>
        <h4>Идея</h4>
        <p>Идея сортировки очень простая. Пусть нам надо отсортировать некоторый кусок массива. Возьмем произвольный элемент в этом куске массива, пусть этот элемент равен $x$. Переставим остальные элементы этого куска так, чтобы сначала шли все элементы $\leq x$, а потом все элементы $\geq x$. (Есть много вариаций на счет того, где тут допускать нестрогое неравенство, а где требовать строгого неравенства.) Это можно сделать за один проход по массиву. После этого осталось отсортировать оба полученных куска по отдельности, что мы и сделаем двумя <i>рекурсивными запусками</i>.</p>
        
        <p>Как именно сделать требуемое разбиение? Обычно делают так: запускают с двух концов рассматриваемого куска массива два указателя. Сначала идут одним указателем слева направо, начиная с левого конца, пропуская числа, которые $&lt;x$ — они вполне себе находятся на своих местах. Когда находиться элемент, который $\geq x$, то указатель останавливается. После этого идут вторым указателем справа налево, начиная с правого конца, пропуская элементы, которые $&gt;x$ — они тоже вполне на своих местах. Когда находят элемент $\leq x$, его меняют местами с тем элементом, который был найден первым указателем. После этого оба этих элемента тоже получаются на своих местах, и указателями идут дальше. И так до тех пор, пока указатели не поменяются местами.</p>
        
        <h4>Реализация</h4>
        <p>Классическая реализация следующая (я взял ее <a href="https://rosettacode.org/wiki/Sorting_algorithms/Quicksort#Pascal">отсюда</a>):</p>
        <pre>// сортируем массив A на участке от left до right
        procedure quicksort(left, right : integer);
        var i, j :integer;
            tmp, x :integer;
        begin
          i:=left;
          j:=right;
          x := A[(left + right) div 2]; // выбираем x, см. обсуждение этой строки ниже
          repeat
            while x&gt;A[i] do inc(i); // пропускаем те элементы, что стоят на своих местах
            while x&lt;A[j] do dec(j); // пропускаем те элементы, что стоят на своих местах
            if i&lt;=j then begin
              // нашли два элемента, которые не на своих местах
              // --- меняем их местами
              tmp:=A[i];
              A[i]:=A[j];
              A[j]:=tmp;
              dec(j);
              inc(i);
            end;
          until i&gt;j;
          // если в левой части больше одного элемента, то отсортируем ее
          if left&lt;j then quicksort(left,j);
          // аналогично с правой
          if i&lt;right then quicksort(i,right);
        end;
        </pre>
        
        <p>И идея, и реализация выглядит просто, но на самом деле здесь полно подводных камней. Попробуйте сейчас осознать этот код, понять его, а потом закройте эту страницу и напишите программу — почти наверняка получившаяся программа работать не будет или будет не всегда. Более того, если вы попытаетесь понять, что в вашей программе не так, и будете сравнивать ее с кодом выше — вы не поймете, почему отличия так важны.</p>
        
        <p>Поэтому, на мой взгляд, единственный способ научиться писать quicksort, по крайней мере на вашем текущем уровне, — это найти точно работающую реализацию и <i>выучить ее наизусть</i> (кстати, я не уверен на 100%, что код, приведенный выше, действительно работает). Может быть, когда вы станете совсем крутыми, вы сможете понять все подводные камни quicksort'а, но вряд ли сейчас. Если же вы не выучили ее наизусть, то настоятельно не рекомендую вам ее писать в реальных задачах. Лучше освойте сортировку слиянием, про которую я пишу ниже.</p>
        
        <h4>Сложность</h4>
        <p>Какова сложность quicksort'а? Если немного подумать головой, то понятно, что <i>в худшем случае</i> ее сложность — $O(N^2)$. Действительно, если каждый раз нам будет не везти и каждый раз мы будем в качестве $x$ выбирать <i>наименьший</i> элемент текущего куска, то каждый раз длина сортируемого куска будет уменьшаться лишь на единицу, и глубина рекурсии получится $N$, и на каждом уровне рекурсии будет примерно $N$ действий — итого $O(N^2)$</p>
        
        <p>Но при этом быстрая сортировка — редчайший пример алгоритма, у которого сложность <i>в среднем</i> лучше, чем <i>в худшем</i> случае. А именно, давайте для начала посмотрим на <i>идеальный</i> случай. В идеальном на каждой итерации массив будет делиться ровно пополам, и глубина рекурсии будет всего лишь $\log N$. Итого сложность $O(N \log N)$. Утверждается, что <i>в среднем</i> (т.е. если входные данные случайны) сложность тоже будет $O(N \log N)$.</p>
        
        <p>Правда, есть подстава: входные данные никогда не случайны. Если мы выбираем $x$ вполне определенным способом, например, как в примере выше — всегда <i>средний</i> элемент массива, то злой пользователь (или злое жюри) сможет всегда подобрать такой пример, чтобы наша сортировка работала совсем плохо, т.е. за $O(N^2)$. (А еще хуже было бы брать всегда самый первый или самый последний элемент — тогда не только злой пользователь мог бы подобрать специальный тест, но и просто если входные данные <i>уже</i> отсортированы, а такое бывает и не у злых пользователей, то сортировка отработает за $O(N^2)$).</p>
        
        <p>Против этого можно бороться, выбирая каждый раз элемент <i>случайным</i> образом, т.е. с помощью <code>random</code>. Только не забудьте сделать <code>randomize</code>, чтобы предугадать, какой вы выберете элемент, было реально сложно.</p>
        
        <h4>$k$-я порядковая статистика</h4>
        <p>Помимо собственно сортировки, у идей quicksort'а есть еще одно применение. Пусть нам дан неотсортированный массив и число $k$. Зададимся вопросом: какое число будет стоять на $k$-м месте, если массив отсортировать? Это число называется $k$-й порядковой статистикой (т.е, например, 137-й порядковой статистикой называется число, которое будет стоять на 137-м месте).</p>
        
        <p>Чтобы найти $k$-ю порядковую статистику, можно, конечно, отсортировать массив — сложность решения будет $O(N\log N)$. Но можно поступить проще. Разобьем массив на две части, как в quicksort'е. Quicksort дальше рекурсивно запускается для обеих полученных частей, но нам этого не надо — мы знаем, сколько элементов в какой части и потому знаем, в какую часть попадает $k$-й элемент. Поэтому нам достаточно сделать только один рекурсивный запуск. В итоге можно доказать, что сложность в среднем получается $O(N)$.</p>
        
        <h3>Сортировка слиянием</h3>
        
        <h4>Слияние двух массивов</h4>
        <p>Сначала рассмотрим более простую задачу. Пусть у нас есть два <i>уже отсортированных</i> массива, и нам надо объединить их в один отсортированный. Например, если есть два массива</p>
        <pre>a1 = 1 6 7 9
        a2 = 2 3 7 10
        </pre>
        <p>то должен получиться массив</p>
        <pre>res = 1 2 3 6 7 7 9 10</pre>
        <p>Как это сделать? Очевидно, что на первом месте должен оказаться либо первый элемент первого массива, либо первый элемент второго массива — т.к. все остальные числа их больше. Выберем тот элемент, который меньше, поставим в выходной массив и удалим при этом его из соответствующего исходного массива:
        </p><pre>a1 =   6 7 9
        a2 = 2 3 7 10
        res = 1
        </pre>
        <p>После этого сравним те два числа, которые теперь оказались в начале исходных массивов (в данном случае 2 и 6). Опять выберем наименьшее из них и переместим его в итоговый массив, и т.д. В итоге за один проход по каждому из исходных массивов мы получим отсортированный массив.</p>
        
        <p>Пишется это достаточно легко. Конечно, мы не будет на самом деле удалять элементы из исходных массивов, а просто мы заведем указатели (индексы) <code>i1</code> и <code>i2</code>, которые будут показывать, какие элементы в обоих исходных массивах являются текущими. Получается следующий код:</p>
        <pre>i1:=1;
        i2:=1;
        for i:=1 to n1+n2 do // n1, n2 -- количество элементов в исходных массивах
            if (i1&lt;=n1) and ( (i2&gt;n2) or (a1[i1]&lt;a2[i2]) ) then begin
                res[i]:=a1[i1];
                inc(i1);
            end else begin
                res[i]:=a2[i2];
                inc(i2);
            end;
        </pre>
        <p>Тут все просто, кроме условия в if. Казалось бы, там должно быть банальное <code>if a1[i1]&lt;a2[i2]</code> — но нет, дело в том, что в какой-то момент один из исходных массивов кончится, и так просто сравнивать не получится. Поэтому там стоит чуть более сложное условие. А именно, когда надо брать элемент из первого массива? Ну, во-первых, конечно, только в том случае, если первый массив еще не кончился: <code>i1&lt;=n1</code>. Во-вторых, если первый массив не кончился, то надо посмотреть на второй массив. Либо второй массив кончился (и тогда точно берем из первого массива), либо он не кончился, и тогда уже надо честно сравнить <code>a1[i1]</code> и <code>a2[i2]</code>. Поэтому ничего особенно сложного в условии if'а нет, все достаточно понятно, если помнить, что массивы могут заканчиваться.</p>
        
        <h4>Собственно сортировка слиянием</h4>
        <p>Теперь исходную задачу сортировки неотсортированного массива можно решить так. Разобьем исходный массив на две половинки. <i>Рекурсивно</i> отсортируем каждую, запустив этот же алгоритм. После этого мы имеем две отсортированные половинки — сольем их так, как описано выше.</p>
        
        <p>Это пишется достаточно легко:</p>
        <pre>var a:array[1..100000] of integer; // массив, который сортируем
            aa:array[1..100000] of integer; // вспомогательный массив
        
        procedure sort(l,r:integer); // сортируем кусок массива от l до r включительно
        var i,i1,i2,o:integer;
        begin
        if l&gt;=r then exit; // если кусок короткий, то сортировать нечего
                           // это же — условие выхода из рекурсии
        o:=(l+r) div 2;
        // разбили на две половинки: (l..o) и (o+1..r)
        // отсортируем
        sort(l,o);
        sort(o+1,r);
        // сольем во временный массив
        i1:=l;
        i2:=o+1;
        for i:=l to r do 
            if (i1&lt;=o)and((i2&gt;r)or(a[i1]&lt;a[i2])) then begin
                aa[i]:=a[i1];
                inc(i1);
            end else begin
                aa[i]:=a[i2];
                inc(i2);
            end;
        // перенесем из временного обратно в основной массив
        for i:=l to r do
            a[i]:=aa[i];
        end;
        </pre>
        <p>В принципе, тут все понятно. Надо только аккуратно записать условие в if'е, не запутавшись, где строгое, а где нестрогое неравенство, но, т.к. вы понимаете аргументацию ("а вдруг массив кончился?"), то всё просто. Кроме того, не запутайтесь, где <code>o</code>, а где <code>o+1</code>, но это тоже просто, т.к. <code>o</code> — последний элемент первой половины массива.</p>
        
        <p>Конечно, сортировку слиянием можно написать несколько быстрее, но обычно это не требуется.</p>
        
        <h4>Сложность</h4>
        <p>Со сложностью сортировки слиянием всё проще. Каждая процедура <code>sort</code> работает за линейное время от длины сортируемого куска, не учитывая рекурсивные запуски. На верхнем уровне рекурсии мы получаем один запуск от всего массива — время $O(N)$. На следующем уровне рекурсии мы получаем два запуска на двух половинках массива, но в сумме эти половинки составляют целый массив, поэтому в сумме время этих двух запусков тоже $O(N)$. На третьем уровне у нас четыре четвертинки, которые в сумме тоже дают $O(N)$. Уровней всего, как несложно видеть, $\log N$, итого получаем сложность $O(N \log N)$.
        
        </p><h4>Подсчет числа инверсий</h4>
        <p>У сортировки слиянием есть следующее применение. Пусть есть неотсортированный массив. <i>Инверсией</i> (или <i>беспорядком</i>) в этом массиве назовем любые два элемента, которые друго относительно друга стоят в неправильном порядке. Например, в массиве 4 3 5 2 есть четыре инверсии: 4 идет раньше 3; 4 идет раньше 2; 3 идет раньше 2; 5 идет раньше 2. </p>
        
        <p>Как можно посчитать количество инверсий? Можно просто проверить все пары, но это будет $O(N^2)$. А можно воспользоваться какой-нибудь сортировкой. А именно, когда в какой-нибудь сортировке мы переставляем какой-нибудь элемент, то посмотрим, сколько других элементов, которые больше его, но которые шли раньше в исходном порядке, он "обогнал". Во многих случаях это получается именно число инверсий, которые "исчезли" в нашем массиве после этой перестановки. В конце в получившемся отсортированном массиве инверсий не будет, поэтому вот сколько в сумме исчезло инверсий, столько их изначально и было.</p>
        
        <p>Самый простой пример — сортировка пузырьком. Каждый раз, когда она меняет два элемента местами, исчезает одна инверсия. Поэтому количество обменов в сортировке пузырьком — это как раз число инверсий. Аналогично в сортировке вставками: когда мы берем очередной элемент и передвигаем его на несколько позиций налево — вот сколько позиций, столько и инверсий мы убрали. А вот в сортировке выбором максимума так просто посчитать инверсии не получится, т.к., когда мы переставляем там элемент, мы не знаем — среди тех элементов, кого он "обогнал", сколько было больше его, а сколько меньше. (Конечно, это можно посчитать, но тогда проще уже честный подсчет инверсий проверкой всех пар сделать.)</p>
        
        <p>По тем же соображениям quicksort не получится адаптировать для подсчета инверсий: когда мы меняем местами два элемента, мы не знаем, сколько инверсий при этом пропадает, т.к. не знаем, какие именно элементы стоят посередине.</p>
        
        <p>А вот сортировку слиянием адаптировать можно. Может быть, это не так очевидно, но, когда мы берем элемент из первой половины (<code>a[i1]</code>), то мы не убираем ни одну инверсию, а когда мы берем элемент из второй половины (<code>a[i2]</code>), то мы убираем <code>o-i1+1</code> инверсию: он обгоняет все еще не взятые элементы первой половины, и при этом все эти элементы больше его. Поэтому получаем следующий код:</p>
        <pre>procedure sort(l,r:integer); // сортируем кусок массива от l до r включительно
        var i,i1,i2,o:integer;
        begin
        if l&gt;=r then exit; // если кусок короткий, то сортировать нечего
                           // это же — условие выхода из рекурсии
        o:=(l+r) div 2;
        // разбили на две половинки: (l..o) и (o+1..r)
        // отсортируем
        sort(l,o);
        sort(o+1,r);
        // сольем во временный массив
        i1:=l;
        i2:=o+1;
        for i:=l to r do 
            if (i1&lt;=o)and((i2&gt;r)or(a[i1]&lt;=a[i2])) then begin
                aa[i]:=a[i1];
                inc(i1);
            end else begin
                inversions:=inversions+o-i1+1; 
                aa[i]:=a[i2];
                inc(i2);
            end;
        // перенесем из временного обратно в основной массив
        for i:=l to r do
            a[i]:=aa[i];
        end;
        </pre>
        <p>Ответ — в переменной <code>inversions</code>. Обратите внимание, что в этом коде есть еще одно отличие от кода сортировки, приведенного выше, и поймите, почему это так.</p></div>""",
                                                      String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>Theory on logarithmic sorting</h2>
        <p>Logarithmic sorts are sorting algorithms that have a complexity of $O(N\log N)$ and use only element comparisons. They allow you to sort an array with a length of 100 000 — 1000 000 in one second. These are the ones you should use in most tasks that require sorting.</p>

        <p>There are a huge number of different logarithmic sorts, but three are really widely used:</p>
        <ul>
        <li>Quick sort, aka Hoare sort, Hoare quick sort, or simply qsort;</li>
        <li>Merge sort;</li>
        <li>Heap sort.</li>
        </ul>
        <p>In this text I will describe merge sorting and quick sorting. Sorting by the heap will be in the topic about the heap at level 5A.</p>

        <h3>QuickSort</h3>
        <h4>Idea</h4>
        <p>The idea of sorting is very simple. Suppose we need to sort some piece of the array. Let's take an arbitrary element in this piece of the array, let this element be equal to $x$. Rearrange the remaining elements of this piece so that all the elements of $\leq x$ go first, and then all the elements of $\geq x$. (There are many variations on where to allow non-strict inequality here, and where to require strict inequality.) This can be done in one pass through the array. After that, it remains to sort both received chunks separately, which we will do with two <i>recursive runs</i>.</p>

        <p>How exactly to do the required partitioning? Usually they do this: they run two pointers from two ends of the considered piece of the array. First, they go with one pointer from left to right, starting from the left end, skipping the numbers that are $&lt;x$ — they are quite in their places. When there is an element that is $\geq x$, the pointer stops. After that, they go with the second pointer from right to left, starting from the right end, skipping the elements that are $>x$ — they are also quite in their places. When the element $\leq x$ is found, it is swapped with the element that was found by the first pointer. After that, both of these elements are also obtained in their places, and the pointers go further. And so on until the pointers are reversed.</p>

        <h4>Implementation</h4>
        <p>The classic implementation is as follows (I took it <a href="https://rosettacode.org/wiki/Sorting_algorithms/Quicksort#Pascal ">from here</a>):</p>
        <pre>// сортируем массив A на участке от left до right
        procedure quicksort(left, right : integer);
        var i, j :integer;
            tmp, x :integer;
        begin
          i:=left;
          j:=right;
          x := A[(left + right) div 2]; // choosing x, see the discussion of this line below
          repeat
            while x&gt;A[i] do inc(i); // we skip those elements that are in their places
            while x&lt;A[j] do dec(j); // we skip those elements that are in their places
            if i&lt;=j then begin
              // found two elements that are out of place
              // --- swap them
              tmp:=A[i];
              A[i]:=A[j];
              A[j]:=tmp;
              dec(j);
              inc(i);
            end;
          until i&gt;j;
          // if there is more than one element in the left part, then sort it
          if left&lt;j then quicksort(left,j);
          // similarly for the right part
          if i&lt;right then quicksort(i,right);
        end;
        </pre>
        
        <p>Both the idea and the implementation look simple, but in fact there are a lot of pitfalls here. Try to understand this code now, understand it, and then close this page and write a program — almost certainly the resulting program will not work or will not always work. Moreover, if you try to understand what is wrong with your program and compare it with the code above, you will not understand why the differences are so important.</p>

        <p>Therefore, in my opinion, the only way to learn how to write quicksort, at least at your current level, is to find an exactly working implementation and <i>learn it by heart</i> (by the way, I'm not 100% sure that the code above really works). Maybe when you get really cool, you'll be able to understand all the pitfalls of quicksort, but it's unlikely now. If you have not learned it by heart, then I strongly do not recommend you to write it in real problems. It's better to master merge sorting, which I write about below.</p>

        <h4>Complexity</h4>
        <p>What is the complexity of quicksort? If you think a little with your head, it is clear that <i>in the worst case </i> its complexity is $O(N^2)$. Indeed, if each time we are unlucky and each time we choose the <i>smallest</i> element of the current piece as $x$, then each time the length of the sorted piece will decrease only by one, and the depth of recursion will be $N$, and at each level of recursion it will be approximately $N$ actions — total $O(N^2)$</p>

        <p>But at the same time, quick sort is the rarest example of an algorithm whose complexity is <i> on average</i> better than <i> in the worst</i> case. Namely, let's first look at the <i>ideal</i> case. Ideally, at each iteration, the array will be divided exactly in half, and the recursion depth will be only $\log N$. Total complexity $O(N\log N)$. It is stated that <i>on average</i> (i.e. if the input data is random) the complexity will also be $O(N\log N)$.</p>

        <p>However, there is a setup: the input data is never random. If we choose $x$ in a very specific way, for example, as in the example above — always the <i>middle</i> element of the array, then an evil user (or an evil jury) will always be able to pick up such an example so that our sorting works very poorly, i.e. for $O(N^2)$. (And it would be even worse to always take the very first or the very last element — then not only an evil user could pick up a special test, but also simply if the input data <i>is already </i> sorted, and this happens not for evil users, then sorting will work for $O(N^2) $).</p>

        <p>You can fight against this by selecting the <i> element each time in a random</i> way, i.e. using <code>random</code>. Just don't forget to do <code>randomize</code> to predict which element you will choose, it was really difficult.</p>

        <h4>$k$-th ordinal statistics</h4>
        <p>In addition to sorting itself, quicksort's ideas have another use. Let us be given an unsorted array and a number $k$. Let's ask ourselves: what number will be in the $k$-th place if the array is sorted? This number is called the $k$th ordinal statistic (i.e., for example, the 137th ordinal statistic is the number that will be in 137th place).</p>

        <p>To find the $k$th ordinal statistics, you can, of course, sort the array - the complexity of the solution will be $O(N\log N)$. But you can do it easier. Let's split the array into two parts, as in quicksort. Quicksort then runs recursively for both received parts, but we don't need this — we know how many elements are in which part and therefore we know which part the $k$th element falls into. Therefore, it is enough for us to make only one recursive run. As a result, we can prove that the average complexity is $O(N)$.</p>

        <h3>Merge sorting</h3>

        <h4>Merging two arrays</h4>
        <p>First, let's look at a simpler problem. Suppose we have two <i>already sorted</i> arrays, and we need to combine them into one sorted. For example, if there are two arrays</p>
        <pre>a1 = 1 6 7 9
        a2 = 2 3 7 10
        </pre>
        <p>then you should get an array</p>
        <pre>res = 1 2 3 6 7 7 9 10</pre>
        <p>How to do it? Obviously, either the first element of the first array or the first element of the second array should be in the first place, since all other numbers are greater than them. Select the element that is smaller, put it in the output array and delete it from the corresponding source array.:        </p><pre>a1 =   6 7 9
        a2 = 2 3 7 10
        res = 1
        </pre>
        <p>After that, let's compare the two numbers that are now at the beginning of the original arrays (in this case, 2 and 6). Again, select the smallest of them and move it to the final array, etc. As a result, in one pass through each of the source arrays, we will get a sorted array.</p>

        <p>It is written quite easily. Of course, we will not actually delete elements from the source arrays, but we will simply create pointers (indexes) <code>i1</code> and <code>i2</code>, which will show which elements in both source arrays are current. The following code is obtained:</p>
        <pre>i1:=1;
        i2:=1;
        for i:=1 to n1+n2 do // n1, n2 -- the number of elements in the source arrays
            if (i1&lt;=n1) and ( (i2&gt;n2) or (a1[i1]&lt;a2[i2]) ) then begin
                res[i]:=a1[i1];
                inc(i1);
            end else begin
                res[i]:=a2[i2];
                inc(i2);
            end;
        </pre>
        <p>Everything is simple here, except for the condition in if. It would seem that there should be a banal <code>if a1[i1]&lt;a2[i2]</code> — but no, the fact is that at some point one of the source arrays will end, and it will not be so easy to compare. Therefore, there is a slightly more complex condition. Namely, when should I take an element from the first array? Well, first of all, of course, only if the first array has not ended yet: <code>i1&lt;=n1</code>. Secondly, if the first array has not ended, then we need to look at the second array. Either the second array has ended (and then we take it from the first array for sure), or it has not ended, and then we must honestly compare <code>a1[i1]</code> and <code>a2[i2]</code>. Therefore, there is nothing particularly complicated in the if condition, everything is quite clear if you remember that arrays can end.</p>

        <h4>Actually merge sorting</h4>
        <p>Now the original problem of sorting an unsorted array can be solved like this. Let's split the source array into two halves. <i>Recursively</i> sort each one by running the same algorithm. After that, we have two sorted halves — we will merge them as described above.</p>

        <p>This is written quite easily:</p>
        <pre>var a:array[1..100000] of integer; // the array that we are sorting
            aa:array[1..100000] of integer; // auxiliary array
        
        procedure sort(l,r:integer); // sorting a piece of the array from l to r inclusive
        var i,i1,i2,o:integer;
        begin
        if l&gt;=r then exit; // if the piece is short, then there is nothing to sort
                           // this is also a condition for exiting recursion
        o:=(l+r) div 2;
        // split into two halves: (l..o) and (o+1..r)
        // let's sort them
        sort(l,o);
        sort(o+1,r);
        // merge into the temporary array
        i1:=l;
        i2:=o+1;
        for i:=l to r do 
            if (i1&lt;=o)and((i2&gt;r)or(a[i1]&lt;a[i2])) then begin
                aa[i]:=a[i1];
                inc(i1);
            end else begin
                aa[i]:=a[i2];
                inc(i2);
            end;
        // move from the temporary array the the main array
        for i:=l to r do
            a[i]:=aa[i];
        end;
        </pre>
        <p>In principle, everything is clear here. You just need to carefully write the condition in the if, without getting confused, where is the strict and where is the non-strict inequality, but since you understand the argument ("what if the array has ended?"), then everything is simple. Also, don't get confused where <code>o</code> is and where <code>o+1</code> is, but it's also simple, because <code>o</code> is the last element of the first half of the array.</p>

        <p>Of course, merge sorting can be written somewhat faster, but it is usually not required.</p>

        <h4>Complexity</h4>
        <p>With the complexity of merge sorting, everything is easier. Each <code>sort</code> procedure works in linear time from the length of the sorted piece, without taking into account recursive runs. At the top level of recursion, we get one run from the entire array — time $O(N)$. At the next level of recursion, we get two runs on two halves of the array, but in total these halves make up the whole array, so in total the time of these two runs is also $O(N)$. At the third level, we have four quarters, which in total also give $O(N)$. The levels of all, as it is easy to see, are $\log N$, in total we get the complexity of $O(N \log N)$.

        </p><h4>Counting the number of inversions</h4>
        <p>Merge sorting has the following application. Let there be an unsorted array. <i>Inversion</i> (or <i>disorder</i>) in this array, we call any two elements that are in the wrong order relative to each other. For example, in the array 4 3 5 2 there are four inversions: 4 goes before 3; 4 goes before 2; 3 goes before 2; 5 goes before 2. </p>

        <p>How can I count the number of inversions? You can just check all pairs, but it will be $O(N^2)$. Or you can use some sort of sorting. Namely, when we rearrange an element in some sort, we will see how many other elements that are larger than it, but which went earlier in the original order, it "overtook". In many cases, it turns out exactly the number of inversions that "disappeared" in our array after this permutation. In the end, there will be no inversions in the resulting sorted array, so that's how many inversions disappeared in total, so many of them were originally.</p>

        <p>The simplest example is bubble sorting. Every time she swaps two elements, one inversion disappears. Therefore, the number of exchanges in bubble sorting is just the number of inversions. Similarly, in sorting by inserts: when we take another element and move it a few positions to the left — that's how many positions, so many inversions we have removed. But in sorting by choosing the maximum, it will not be so easy to calculate inversions, because when we rearrange an element there, we do not know — among those elements whom it "overtook", how many were more than it, and how many were less. (Of course, this can be calculated, but then it's easier to make an honest calculation of inversions by checking all pairs.)</p>

        <p>For the same reasons, quicksort cannot be adapted to count inversions: when we swap two elements, we do not know how many inversions disappear, because we do not know which elements are in the middle.</p>

        <p>But merge sorting can be adapted. Maybe it's not so obvious, but when we take an element from the first half (<code>a[i1]</code>), then we don't remove any inversion, and when we take an element from the second half (<code>a[i2]</code>), then we remove the <code>o-i1+1</code> inversion: it overtakes the elements of the first half that have not yet been taken, and at the same time all these elements are larger than it. Therefore, we get the following code:</p>
        <pre>procedure sort(l,r:integer);
        var i,i1,i2,o:integer;
        begin
        if l&gt;=r then exit;
        o:=(l+r) div 2;
        sort(l,o);
        sort(o+1,r);
        i1:=l;
        i2:=o+1;
        for i:=l to r do 
            if (i1&lt;=o)and((i2&gt;r)or(a[i1]&lt;=a[i2])) then begin
                aa[i]:=a[i1];
                inc(i1);
            end else begin
                inversions:=inversions+o-i1+1; 
                aa[i]:=a[i2];
                inc(i2);
            end;
        for i:=l to r do
            a[i]:=aa[i];
        end;
        </pre>
        <p>The answer is in the variable <code>inversions</code>. Note that there is another difference in this code from the sorting code given above, and understand why this is so.</p></div>"""), {skipTree: true})

export default sorting = () ->
    return {
        topic: topic(
            ruen("Сортировки", "Sorting"),
            ruen("Задачи на сортировки", "Problems on sorting"),
        [label(ruen(
             "Видеозаписи лекций ЛКШ по квадратичным сортировкам: <a href=\"https://sis.khashaev.ru/2013/august/c-prime/kBHwr_e_aAg/\">сортировка пузырьком</a>, <a href=\"https://sis.khashaev.ru/2013/august/c-prime/gZGwKXwjffg/\">выбором максимума</a>. К сожалению, теории по сортировкой вставками тут пока нет. Найдите в интернете или прослушайте на занятии.",
             "Video recordings of lectures of the SIS on quadratic sorting: <a href=\"https://sis.khashaev.ru/2013/august/c-prime/kBHwr_e_aAg/\">bubble sort</a>, <a href=\"https://sis.khashaev.ru/2013/august/c-prime/gZGwKXwjffg/\">selecting maximum</a>. Unfortunately, there is no theory on insertion sort here yet. Find it on the Internet.")),
            label(ruen(
                "Внимание! В задаче \"Библиотечный метод\" надо выводить очередную строку только если состояние массива при этой вставке изменилось.",
                "Attention! In the \"Library Method\" problem , it is necessary to output the next line only if the state of the array has changed during this insertion.")),
            module16475(),
            problem(230),
            problem(1436),
            problem(1411),
            problem(1099),
            problem(39),
            problem(1442),
            problem(766),
            problem(1418),
        ], "sorting"),
        advancedProblems: [
            problem(767),
            problem(3142),
            problem(720),
            problem(1137),
            problem(111628),
            problem(1630),
            problem(111162),
            problem(111751),
        ]
    }