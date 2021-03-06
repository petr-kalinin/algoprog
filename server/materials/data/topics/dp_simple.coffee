import contest from "../../lib/contest"
import label from "../../lib/label"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

module17576 = () ->
    page("О связи перебора и ДП, или Как переборные решения превращать в ДП", String.raw"""
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>О связи перебора и ДП, или Как переборные решения превращать в ДП</h1>
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
        
        <p>Так что обратите внимание еще раз на то, как легко мы придумали эти подзадачи. Если вы не думали про перебор, то может показаться очень неочевидным, что параметром динамики надо взять <i>сумму, которую надо набрать</i> (или которую уже набрали) — но если вы уже подумали про переборное решение и задались вопросом "от чего зависит результат вызова <code>find</code>" — то это становится почти очевидным.</p></div>
    """, {skipTree: true})

export default arrays = () ->
    return {
        topic: topic("Основы динамического программирования", "Простые задачи на ДП", [
            label("<a href=\"https://notes.algoprog.ru/dynprog/index.html\">Теория про ДП</a> (вплоть до самой провинутой, пока читайте только основы)"),
            module17576(),
            label("<div style=\"display:inline-block;\">См. также <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Динамические программирование»<br>\nСм. также <a href=\"https://sis.khashaev.ru/2008/august/b-prime/\">видеозаписи лекций ЛКШ параллели B'.2008</a>, раздел «Динамические программирование» (в параллели B' уже есть и довольно продвинутые темы, которые вам пока не нужны)</div>"),
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