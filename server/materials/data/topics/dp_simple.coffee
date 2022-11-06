import contest from "../../lib/contest"
import label from "../../lib/label"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module17576 = () ->
    page(ruen(
        "О связи перебора и ДП, или Как переборные решения превращать в ДП",
        "About the connection of backtracking and DP, or How to turn recursive backtracking solutions into DP"), ruen(
                                                                                  String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>О связи перебора и ДП, или Как переборные решения превращать в ДП</h1>
        <p>(Со временем я добавлю этот текст в основной текст про ДП. Этот материал не является обязательным на уровне 3. Если вы не освоили рекурсивный перебор, то пропустите и этот материал. Если вы освоили рекурсивный перебор, то прочитайте этот текст и постарайтесь его понять, хотя на самом деле для решения задач уровня 3 идеи, изложенные ниже, не обязательны, на уровне 3 в ДП задачи довольно простые.)</p>
        
        <h2>Пример: последовательности из нулей и единиц</h2>
        
        <p>Пусть вы придумали переборное решение к некоторой задаче. Часто бывает так, что его несложно превратить в решение динамическим программированием. Например, рассмотрим нашу любимую задачу про последовательности из нулей и единиц без двух единиц подряд. Пусть мы не додумались до решения ДП. Давайте напишем переборное решение с адекватными отсечениями:</p>
        <pre>var ans:integer;
            a:array[1..100] of integer;
            n:integer;
        
        procedure check;
        begin
        inc(ans);
        end;
        
        procedure find(i:integer);
        begin
        if i&gt;n then begin
            check;
            exit;
        end;
        a[i]:=0;
        find(i+1);
        if (i=1)or(a[i-1]=0) then begin
            a[i]:=1;
            find(i+1);
        end;
        end;
        
        begin
        read(n);
        ans:=0;
        find(1);
        writeln(ans);
        end.
        </pre>
        
        <p>У этой реализации есть недостаток, который нам будет сейчас мешать — это глобальная переменная <code>ans</code>. Давайте перепишем код так, чтобы он не использовал глобальную переменную: сделаем все процедуры <i>функциями</i>, возвращающими, <i>сколько последовательностей они нашли:</i></p>
        <pre>var ans:integer;
            a:array[1..100] of integer;
            n:integer;
        
        function check:integer;
        begin
        result:=1;
        end;
        
        function find(i:integer):integer;
        begin
        if i&gt;n then begin
            result:=check;
            exit;
        end;
        a[i]:=0;
        result:=find(i+1);
        if (i=1)or(a[i-1]=0) then begin
            a[i]:=1;
            result:=result+find(i+1);
        end;
        end;
        
        begin
        read(n);
        ans:=find(1);
        writeln(ans);
        end.
        </pre>
        <p>Т.е. помните мотивировку рекурсивного перебора? "Функция <code>find</code> предполагает, что мы уже заполнили первые $i-1$ элементов массива и перебирает варианты заполнения оставшихся." Так вот, в модифицированном варианте функция будет еще и <i>возвращать</i> количество способов заполнить оставшиеся. Осознайте, почему это работает.</p>
        
        <p>А теперь самое главное. Зададимся вопросом: <i>от чего на самом деле зависит результат работы функции <code>find</code>?</i> Пусть, например, мы рассматриваем запуск <code>find(15)</code>. Это обозначает, что мы заполнили первые 14 элементов массива. Так вот: зависит ли возвращаемое значение функции <code>find(15)</code> от <i>всех значений всех этих элементов</i>?</p>
        
        <p>Достаточно очевидно, что нет. Более того, если подумать, то понятно, что возвращаемое значение зависит только от собственно <code>i</code>, а также от значения <code>a[i-1]</code>. Значения предыдущих элементов массива нам не важны. Например, результат вызова <code>find(5)</code> будет один и тот же, если массив <code>a</code> перед вызовом равен <code>1 0 1 1</code> или <code>0 1 1 1</code>, но для массива <code>1 0 1 0</code> результат будет другой.</p>
        
        <p>Это позволяет резко ускорить решение, причем двумя способами. Первый способ состоит в том, чтобы распознавать ситуации, эквивалентные тем, которые мы уже решали раньше — и не перерешивать заново. А именно, пусть мы запускаем <code>find(i)</code>, и при этом <code>a[i-1]=x</code>. Запишем результат этой процедуры в специальный массив <code>res</code> в элемент <code>res[i,x]</code>. После этого когда окажется, что мы опять запускаем <code>find(i)</code> с тем же самым <code>i</code> и тем же самым <code>a[i-1]</code>, то мы не будем все рассчитывать заново, а просто сразу вернем значение, уже записанное в <code>res[i,x]</code>. Примерно так:</p>
        <pre>var res:array[1..100,0..1] of integer;
            ...
        
        function find(i:integer):integer;
        begin
        if i&gt;n then begin
            result:=check;
            exit;
        end;
        if res[i,a[i-1]]=-1 then begin // если мы еще не решали эту задачу
            a[i]:=0;
            res[i,a[i-1]]:=find(i+1);
            if (i=1)or(a[i-1]=0) then begin
                a[i]:=1;
                res[i,a[i-1]]:=res[i,a[i-1]]+find(i+1);
            end;
        end;
        result:=res[i,a[i-1]];
        end;
        </pre>
        <p>Это еще не совсем рабочий код, в нем надо как минимум аккуратно разобраться со случаем <code>i=1</code>, а еще можно и функцию <code>check</code> исключить, но, я думаю, идея понятна. Собственно, это то, что называется рекурсией с запоминанием результата, и это уже полноценное ДП.</p>
        
        <p>Но чтобы более четко понять, что происходит, и написать уже совсем классическое ДП, пойдем немного другим способом. А именно, заметив, что ответ зависит только от <code>i</code> и <code>a[i-1]</code>, попробуем сразу это и сделать подзадачами ДП. А именно, давайте для каждого <code>i</code> и <code>x</code> вычислим <code>res[i,x]</code> как значение, которое вернет наша функция <code>find(i)</code>, запущенная в ситуации, когда <code>a[i-1]=x</code>. Результат функции зависит только от <code>i</code> и <code>x</code>, поэтому наш вопрос корректен.</p>
        
        <p>Как мы будем вычислять <code>res[i,x]</code>? У нас уже есть функция <code>find</code>, и она фактически документирует способ этого вычисления. Во-первых, если <code>i&gt;n</code>, то ответ будет <code>1</code>. Иначе функция <code>find</code> рекурсивно запускает себя один или два раза в зависимости от <code>a[i-1]</code> (т.е. <code>x</code>). Несложно прямо из когда нашей функции видеть, что выполняется следующее соотношение:</p>
        <pre>res[i,x]=res[i+1,0]             если x=1
        res[i,x]=res[i+1,0]+res[i+1,1]  если x=0
        </pre>
        
        <p>Вот и готова динамика! Несложно также видеть, что нам надо идти по убыванию <code>i</code>, т.к. каждая подзадача зависит от подзадач с бОльшим <code>i</code>, и теперь решение пишется легко:</p>
        <pre>res[n+1,0]:=1;
        res[n+1,1]:=1; // это особые случаи, отвечающие функции check
        for i:=n downto 1 do begin
            res[i,1]:=res[i+1,0];
            res[i,0]:=res[i+1,0]+res[i+1,1];
        end;
        writeln(res[1,0]); // поймите, почему именно так?
        </pre>
        
        <p>Вот и все. Мы придумали подзадачи и получили рекуррентное соотношение, просто задавшись одним вопросом: от чего на самом деле зависит результат функции <code>find</code>?</p>
        
        <p>Конечно, его можно улучшить: можно первую формулу подставить во вторую:</p>
        <pre>res[i,0]=res[i+1,0]+res[i+2,0]
        </pre>
        <p>И теперь мы видим, что элементы с <code>x=1</code> нам больше не нужны, и переобозначая <code>res[i,0]</code> как просто <code>res[i]</code>, получаем уже привычное рекуррентное соотношение для этой задачи. Правда, пожалуй, рекуррентные соотношения с двумя элементами массива, в общем-то, представляются даже более естественными для этой задачи.</p>
        
        <p>Оно (да и рекуррентные соотношения выше), правда, записано "задом-наперед", но это не так страшно. Если подумать, то все понятно: в обычной динамике мы задавались вопросом "как можно заполнить первые <code>i</code> позиций" (т.е. сколько есть решений длины <code>i</code>), а тут мы задаемся вопросов "как можно заполнить последние <code>n-i</code> позиций" (так и работал перебор). Поэтому и цикл от <code>n</code> вниз, и рекуррентное соотношение ссылается на бОльшие <code>i</code>. Но это уже детали. </p>
        
        <h2>Общая идея</h2>
        <p>Итак, общая идея. Пусть вы придумали переборное решение к некоторой задаче. Придумайте его так, чтобы ваша функция <code>find</code> <i>возвращала</i> результат, а не работала бы с какими-нибудь глобальными переменными. Подумайте, от чего зависит результат, возвращаемый вашей функцией. Часто он будет зависеть не от всего множества выборов, которые вы сделали раньше, а от некоторой характеристики этого множества. Отлично, теперь вот все возможные значения этой характеристики (или нескольких характеристик) и станут подзадачами в вашей динамике; а то, как работала бы ваша функция, станет рекуррентным соотношением.</p>
        
        <p>Вам даже не обязательно непосредственно <i>писать</i> рекурсивный код; вы можете просто <i>представить</i> его в уме.</p>
        
        <p>Конечно, этот подход будет работать не всегда. Зачастую задачу можно решить перебором разными способами, и только некоторые из них приведут к хорошему решению динамикой. Но тем не менее подход, как мне кажется, весьма полезен.</p>
        
        <h2>Пример: набор заданной суммы данным набором монет</h2>
        <p>Нам надо набрать некоторую сумму <code>S</code>, используя монеты достоинством <code>a[1]</code>, <code>a[2]</code>, ..., <code>a[n]</code>. Каждую монету можно использовать не более одного раза.</p>
        
        <p>Давайте придумаем переборное решение. Помня, что динамика из перебора получается "задом-наперед", я сразу придумаю перебор "задом-наперед", чтобы динамика получилась нормальной. А именно, я буду запускать из главной программы <code>find(n)</code>, она будет решать, берем ли мы <code>n</code>-ую монету и запускать <code>find(n-1)</code> и т.д.:</p>
        
        <pre>function check:boolean;
        var cursum:integer;
            i:integer;
        begin
        for i:=1 to n do
            if taken[i]=1 then
                cursum:=cursum+a[i];
        result:=cursum=s;
        end;
        
        function find(i:integer):boolean;
        begin
        if i=0 then begin
            result:=check;
            exit;
        end;
        taken[i]:=0;
        result:=find(i-1);
        taken[i]:=1;
        result:=result or find(i-1);
        end;
        
        begin
        ...
        fillchar(taken,sizeof(taken),0);
        res:=find(n);
        writeln(res);
        end.
        </pre>
        
        <p>Я даже тут не стал делать никаких отсечений. Я просто перебираю все варианты "брать-не брать" и потом проверяю, получилась ли нужная сумма.</p>
        
        <p>Давайте подумаем, от чего зависит результат функции <code>find</code>. Если немного подумать, то несложно понять, что нам действительно не надо знать, какие конкретно числа мы поставили в массив <code>taken</code>, т.е. какие конкретно монеты мы решили брать. Нам надо лишь знать <i>общую сумму</i>, которую мы уже набрали этими монетами. Ну и <code>i</code>, конечно, тоже надо знать.</p>
        
        <p>Обозначая уже набранную сумму как <code>x</code>, получаем сразу рекуррентное соотношение для динамики:</p>
        
        <code>
        res[i,x]=res[i-1,x] or res[i-1,x+a[i]]
        </code>
        
        <p>Собственно, это и есть стандартное рекуррентное соотношение для этой задачи; только обычно вместо <code>x</code> используют <code>S-x</code> — сумму, которую <i>осталось</i> набрать, но это несущественно. Кроме того, можно только еще догадаться, что решать подзадачи с <code>x&gt;S</code> не надо — и добавить соответствующий <code>if</code>, но это уже технические детали, которые несложно добавить (да и не всегда необходимо).</p>
        
        <p>Так что обратите внимание еще раз на то, как легко мы придумали эти подзадачи. Если вы не думали про перебор, то может показаться очень неочевидным, что параметром динамики надо взять <i>сумму, которую надо набрать</i> (или которую уже набрали) — но если вы уже подумали про переборное решение и задались вопросом "от чего зависит результат вызова <code>find</code>" — то это становится почти очевидным.</p></div>""",

                                                                                  String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>About the connection of recursive backtracking and DP, or How to turn recursive backtrack solutions into DP</h1>
        <p>(Over time, I will add this text to the main text about DP. This material is optional at level 3. If you haven't mastered recursive iteration, then skip this material as well. If you have mastered recursive brute force, then read this text and try to understand it, although in fact the ideas outlined below are not necessary to solve level 3 problems, at level 3 in DP the tasks are quite simple.)</p>
        
        <h2>Example: sequences of zeros and ones</h2>

        <p>Let's say you have come up with an over-the-top solution to some problem. It often happens that it is not difficult to turn it into a solution by dynamic programming. For example, consider our favorite problem about sequences of zeros and ones without two ones in a row. Let us not have thought of the DP solution. Let's write a bulkhead solution with adequate cut-offs:</p>        <pre>var ans:integer;
            a:array[1..100] of integer;
            n:integer;
        
        procedure check;
        begin
        inc(ans);
        end;
        
        procedure find(i:integer);
        begin
        if i&gt;n then begin
            check;
            exit;
        end;
        a[i]:=0;
        find(i+1);
        if (i=1)or(a[i-1]=0) then begin
            a[i]:=1;
            find(i+1);
        end;
        end;
        
        begin
        read(n);
        ans:=0;
        find(1);
        writeln(ans);
        end.
        </pre>
        
        <p>This implementation has a drawback that will hinder us now — this is the global variable <code>ans</code>. Let's rewrite the code so that it doesn't use a global variable: let's make all procedures <i>functions</i> that return <i>how many sequences they found:</i></p>        <pre>var ans:integer;
            a:array[1..100] of integer;
            n:integer;
        
        function check:integer;
        begin
        result:=1;
        end;
        
        function find(i:integer):integer;
        begin
        if i&gt;n then begin
            result:=check;
            exit;
        end;
        a[i]:=0;
        result:=find(i+1);
        if (i=1)or(a[i-1]=0) then begin
            a[i]:=1;
            result:=result+find(i+1);
        end;
        end;
        
        begin
        read(n);
        ans:=find(1);
        writeln(ans);
        end.
        </pre>
        <p>That is, do you remember the motivation of recursive iteration? "The <code>find</code> function assumes that we have already filled in the first $i-1$ elements of the array and iterates over the options for filling in the remaining ones." So, in the modified version, the function will also <i>return </i> the number of ways to fill in the remaining ones. Realize why it works.</p>

        <p>And now the most important thing. Let's ask ourselves the question: <i> what does the result of the <code>find</code> function really depend on?</i> Let's say, for example, we are considering running <code>find(15)</code>. This means that we have filled in the first 14 elements of the array. So: does the return value of the <code>find(15)</code> function depend on <i> all the values of all these elements</i>?</p>

        <p>It's pretty obvious that there isn't. Moreover, if you think about it, it is clear that the return value depends only on the actual <code>i</code>, as well as on the value of <code>a[i-1]</code>. The values of the previous array elements are not important to us. For example, the result of calling <code>find(5)</code> will be the same if the array <code>a</code> before the call is <code>1 0 1 1</code> or <code>0 1 1 1</code>, but for array <code>1 0 1 0</code> the result will be different.</p>

        <p>This allows you to dramatically speed up the solution, and in two ways. The first way is to recognize situations that are equivalent to those that we have already solved before — and not to re-solve. Namely, let's run <code>find(i)</code>, and at the same time <code>a[i-1]=x</code>. Let's write the result of this procedure in a special array <code>res</code> in the element <code>res[i,x]</code>. After that, when it turns out that we are running <code>find(i)</code> again with the same <code>i</code> and the same <code>a[i-1]</code>, then we will not calculate everything again, but simply immediately return the value already written in <code>res[i,x]</code>. Something like this:</p>        
        <pre>var res:array[1..100,0..1] of integer;
            ...
        
        function find(i:integer):integer;
        begin
        if i&gt;n then begin
            result:=check;
            exit;
        end;
        if res[i,a[i-1]]=-1 then begin // if we haven't solved this subproblem yet
            a[i]:=0;
            res[i,a[i-1]]:=find(i+1);
            if (i=1)or(a[i-1]=0) then begin
                a[i]:=1;
                res[i,a[i-1]]:=res[i,a[i-1]]+find(i+1);
            end;
        end;
        result:=res[i,a[i-1]];
        end;
        </pre>
        <p>This is not quite working code yet, it needs at least to carefully deal with the case of <code>i=1</code>, and you can also exclude the <code>check</code> function, but I think the idea is clear. Actually, this is what is called recursion with memorization of the result, and this is already a full-fledged DP.</p>

        <p>But in order to understand more clearly what is happening and write a completely classic DP, let's go a little differently. Namely, having noticed that the answer depends only on <code>i</code> and <code>a[i-1]</code>, let's try to do it right away and do it with DP subtasks. Namely, let's calculate for each <code>i</code> and <code>x</code> <code>res[i,x]</code> as the value that our <code>find(i)</code> function, launched in the situation, returns when <code>a[i-1]=x</code>. The result of the function depends only on <code>i</code> and <code>x</code>, so our question is correct.</p>

        <p>How will we calculate <code>res[i,x]</code>? We already have the <code>find</code> function, and it actually documents the way this calculation is done. First, if <code>i>n</code>, then the answer will be <code>1</code>. Otherwise, the <code>find</code> function recursively runs itself once or twice depending on <code>a[i-1]</code> (i.e. <code>x</code>). It is not difficult to see right from the beginning of our function that the following relation holds:</p>
        <pre>res[i,x]=res[i+1,0]             if x=1
        res[i,x]=res[i+1,0]+res[i+1,1]  if x=0
        </pre>
        
        <p>Now the dynamics are ready! It is also easy to see that we need to go in descending order <code>i</code>, because each subtask depends on subtasks with a large <code>i</code>, and now the solution is written easily:</p>        <pre>res[n+1,0]:=1;
        res[n+1,1]:=1; // these are special cases that correspond to the check function
        for i:=n downto 1 do begin
            res[i,1]:=res[i+1,0];
            res[i,0]:=res[i+1,0]+res[i+1,1];
        end;
        writeln(res[1,0]); // do understand why this is so
        </pre>
        
        <p>That's it. We came up with subtasks and got a recurrence relation, just asking one question: what does the result of the <code>find</code> function really depend on?</p>

        <p>Of course, it can be improved: you can substitute the first formula into the second:</p>
        <pre>res[i,0]=res[i+1,0]+res[i+2,0]
        </pre>
        <p>And now we see that we no longer need elements with <code>x=1</code>, and reinterpreting <code>res[i,0]</code> as just <code>res[i]</code>, we get the already familiar recurrence relation for this task. True, perhaps, recurrent relations with two elements of the array, in general, seem even more natural for this task.</p>

        <p>It (and the recurrence relations are higher), however, is written "backwards", but it's not so scary. If you think about it, then everything is clear: in normal dynamics, we were wondering "how can I fill the first <code>i</code> positions" (i.e. how many solutions of length <code>i</code> are there), and here we are asking questions "how can I fill the last <code>n-i</code> positions" (this is how the brute force worked). Therefore, both the cycle from <code>n</code> downwards, and the recurrence relation refers to large <code>i</code>. But these are details. </p>

        <h2>General idea</h2>
        <p>So, the general idea. Let's say you have come up with an over-the-top solution to some problem. Think of it so that your <code>find</code> <i> function returns </i> the result, and does not work with any global variables. Think about what the result returned by your function depends on. Often it will depend not on the whole set of choices that you have made before, but on some characteristic of this set. Great, now here are all the possible values of this characteristic (or several characteristics) and will become subtasks in your dynamics; and how your function would work will become a recurrence relation.</p>

        <p>You don't even have to directly <i> write </i> recursive code; you can just <i>imagine</i> it in your mind.</p>

        <p>Of course, this approach will not always work. Often the problem can be solved by brute force in different ways, and only some of them will lead to a good dynamic solution. But nevertheless, the approach, it seems to me, is very useful.</p>

        <h2>Example: a set of a given amount by a given set of coins</h2>
        <p>We need to collect some amount of <code>S</code> using coins of the denominations <code>a[1]</code>, <code>a[2]</code>, ..., <code>a[n]</code>. Each coin can be used no more than once.</p>

        <p>Let's come up with an overkill solution. Remembering that the dynamics of the brute force turns out "backwards", I will immediately come up with a brute force "backwards" so that the dynamics turn out to be normal. Namely, I will run <code>find(n)</code> from the main program, it will decide whether we take the <code>n</code>th coin and run <code>find(n-1)</code>, etc.:</p>

        <pre>function check:boolean;
        var cursum:integer;
            i:integer;
        begin
        for i:=1 to n do
            if taken[i]=1 then
                cursum:=cursum+a[i];
        result:=cursum=s;
        end;
        
        function find(i:integer):boolean;
        begin
        if i=0 then begin
            result:=check;
            exit;
        end;
        taken[i]:=0;
        result:=find(i-1);
        taken[i]:=1;
        result:=result or find(i-1);
        end;
        
        begin
        ...
        fillchar(taken,sizeof(taken),0);
        res:=find(n);
        writeln(res);
        end.
        </pre>
        
        <p>I didn't even make any cuts here. I'm just going through all the options "to take-not to take" and then check if the right amount has turned out.</p>

        <p>Let's think about what the result of the <code>find</code> function depends on. If you think a little, it's easy to understand that we really don't need to know which specific numbers we put in the <code>taken</code> array, i.e. which specific coins we decided to take. We just need to know <i>the total amount</i> that we have already collected with these coins. Well, <code>i</code>, of course, you also need to know.</p>

        <p>Denoting the amount already typed as <code>x</code>, we immediately get a recurrent ratio for dynamics:</p>

        <code>
        res[i,x]=res[i-1,x] or res[i-1,x+a[i]]
        </code>
        
        <p>Actually, this is the standard recurrence relation for this task; only usually, instead of <code>x</code>, <code>S-x</code> is used — the amount that <i> remains</i> to dial, but this is insignificant. In addition, one can only guess that it is not necessary to solve subtasks with <code>x&gt;S</code> — and add the corresponding <code>if</code>, but these are technical details that are easy to add (and not always necessary).</p>

        <p>So pay attention once again to how easily we came up with these subtasks. If you have not thought about overkill, then it may seem very unobvious that the dynamics parameter should be <i>the amount to be typed</i> (or which you have already typed) — but if you have already thought about the overkill solution and wondered "what determines the result of the call <code>find</code>" — then it becomes almost obvious.</p></div>"""), {skipTree: true})

export default arrays = () ->
    return {
        topic: topic(
            ruen("Основы динамического программирования", "Basics of dynamic programming"),
            ruen("Простые задачи на ДП", "Simple DP tasks"),
        [label(ruen(
             "<a href=\"https://notes.algoprog.ru/dynprog/index.html\">Теория про ДП</a> (вплоть до самой провинутой, пока читайте только основы)",
             "Another wide topic, bu fortunately you don't need to study advanced parts of DP now.
             <a href=\"https://www.geeksforgeeks.org/dynamic-programming/\">Theory on GeeksForGeeks</a> (read \"Basic Concepts\" and some \"Basic Problems\"),<br/>
             <a href='https://soi.ch/wiki/basic-dp/'>Basic theory on SOI.ch</a>")),
            module17576(),
            label(ruen(
                "<div style=\"display:inline-block;\">См. также <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Динамические программирование»<br>\nСм. также <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ параллели B'.2008</a>, раздел «Динамические программирование» (в параллели B' уже есть и довольно продвинутые темы, которые вам пока не нужны)</div>",
                null)),
            problem(201),
            problem(842),
            problem(843),
            problem(913),
            problem(912),
            problem(914),
            problem(203),
            problem(915),
            problem(206),
            problem(2998),
        ], "dp_simple"),
        advancedProblems: [
            problem(944),
            problem(2999),
            problem(210),
            problem(2963),
            problem(3003),
            problem(619),
            problem(1119),            
            problem(1129),
            problem(1758),
            problem(637),
            problem(492),
            problem(111702),
        ]
    }