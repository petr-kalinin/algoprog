import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module16828 = () ->
    page(ruen(
        "Разбор задачи \"Резисторы\"",
        "Analysis of the problem \"Resistors\""), ruen(
                                            String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Разбор задачи "Резисторы"</h1>
        <p>(В этой задаче все равно — говорить про резисторы или про конденсаторы, т.к. формулы соединения аналогичны, только для резисторов для последовательного соединения формула та же, что для конденсаторов для параллельного, и наоборот. На задачу это не влияет. Я для удобства буду говорить про резисторы, а не про конденсаторы.)</p>
        <p>"Резисторы" — это задача, скажем так, "общего вида" на перебор. А именно, если в других задачах на перебор вы обычно формируете какую-нибудь <i>последовательность</i>, последовательно к текущему решению добавляя что-то еще, то здесь так просто не получится. </p>
        <p>Вы можете попробовать делать так: у вас есть некоторая текущая схема. Вы берете очередной еще не использованный резистор и присоединяете его к текущей схеме или последовательно или параллельно. Потом берете очередной еще не использованный резистор и т.д. Но с таким решением есть проблема: вы не сможете получить по-настоящему сложную схему. Например, рассмотрим следующую схему:</p>
        <pre>         +--D-E-+
         +-A--B--+      +--+
        -+       +--F-G-+  +---
         |                 | 
         +-G--H--+--I--+---+
                 |     |
                 +-J-K-+ 
        </pre>
        <p>(буквы обозначают резисторы)</p>
        <p>Вы ее получить не сможете, т.к. тут надо сначала собрать несколько отдельных схем, а потом уже их объединить в одну.</p>
        <p>Вы можете попробовать собирать сразу две схемы, но все равно вы не сможете полностью покрыть все разнообразие решений.</p>
        <p>Поэтому эту задачу можно решать по-другому. А именно, переформулируем ее так. У нас на столе лежат N резисторов. Мы можем взять два из них, убрать, а вместо них положить резистор, равный или последовательно соединенным этим двум резисторам, или параллельно соединенным. Т.е. любые два резистора мы можем заменить на результат их последовательного или параллельного соединения. После этого мы можем опять взять два любых резистора (в том числе и тот, который только получили из предыдущих двух) и заменить на один. И т.д. Ясно, что вот это как раз покрывает все разнообразие схем, т.к. никто нас не заставляет все время наращивать одну конкретную схему, мы можем сначала собрать несколько кусков, а потом их как надо объединить.</p>
        <p>И это очень легко реализуется. Процедура <code>find</code> будет выбирать два резистора, заменять их на одно, и запускаться рекурсивно.</p>
        <pre>var r:array[...] of extended; // резисторы, которые сейчас лежат на столе
            n:integer; // количество резисторов
        procedure find;
        var i,j:integer;
            r1,r2:extended;
        begin
        for i:=1 to n do
            for j:=i+1 to n do begin
                r1:=r[i];
                r2:=r[j];
                // начинается магия, поймите ее!
                r[j]:=r[n];
                dec(n);
                r[i]:=r1+r2;
                find;
                r[i]:=r1*r2/(r1+r2);
                find;
                inc(n);
                r[n]:=r[j];
                r[i]:=r1;
                r[j]:=r2;
            end;
        end;
        </pre>
        <p>Вот и все. Даже не надо проверки на выход из рекурсии, т.к. когда станет <code>n=1</code>, то циклы не выполнятся ни разу. Осталось только проверять все получающиеся резисторы на предмет того, не получается ли хорошее решение, это проще всего сделать циклом по всем имеющимся резисторам в начале процедуры find.</p>
        
        <p>Что тут важно. Что тут решение строится не путем последовательных добавлений, а что вы честно исследуете все возможные пути. Можете думать об этом как о некоторой игре, в которой есть позиции (какие резисторы на столе) и возможные ходы из каждой позиции, и вы просто перебираете такие ходы.</p></div>""",
                                            String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Analysis of the problem "Resistors"</h1>
        <p>(In this problem, it's all the same — to talk about resistors or about capacitors, because the connection formulas are similar, only for resistors for serial connection, the formula is the same as for capacitors for parallel, and vice versa. This does not affect the task. For convenience, I will talk about resistors, not capacitors.)</p>
        <p>"Resistors" is a task, let's say, of a "general kind" for brute force. Namely, if in other search tasks you usually form some kind of <i>sequence</i>, sequentially adding something else to the current solution, then it will not work so easily here. </p>
        <p>You can try doing this: you have some current schema. You take another unused resistor and attach it to the current circuit either in series or in parallel. Then you take another not yet used resistor, etc. But there is a problem with this solution: you will not be able to get a truly complex scheme. For example, consider the following scheme:</p>
        <pre>         +--D-E-+
         +-A--B--+      +--+
        -+       +--F-G-+  +---
         |                 | 
         +-G--H--+--I--+---+
                 |     |
                 +-J-K-+ 
        </pre>
        <p>(letters denote resistors)</p>
        <p>You will not be able to get it, because here you need to first assemble several separate schemes, and then combine them into one.</p>
        <p>You can try to assemble two schemes at once, but still you will not be able to fully cover all the variety of solutions.</p>
        <p>Therefore, this task can be solved in a different way. Namely, we reformulate it like this. We have N resistors on the table. We can take two of them, remove them, and instead put a resistor equal to either the two resistors connected in series or connected in parallel. That is, we can replace any two resistors with the result of their serial or parallel connection. After that, we can again take any two resistors (including the one that we just received from the previous two) and replace it with one. Etc. It is clear that this just covers the whole variety of schemes, because no one forces us to build up one specific scheme all the time, we can first assemble several pieces, and then combine them properly.</p>
        <p>And it is very easy to implement. The <code>find</code> procedure will select two resistors, replace them with one, and run recursively.</p>
        <pre>var r:array[...] of extended; // resistors that are currently lying on the table
            n:integer; // number of resistors
        procedure find;
        var i,j:integer;
            r1,r2:extended;
        begin
        for i:=1 to n do
            for j:=i+1 to n do begin
                r1:=r[i];
                r2:=r[j];
                // the magic begins, understand it!
                r[j]:=r[n];
                dec(n);
                r[i]:=r1+r2;
                find;
                r[i]:=r1*r2/(r1+r2);
                find;
                inc(n);
                r[n]:=r[j];
                r[i]:=r1;
                r[j]:=r2;
            end;
        end;
        </pre>
        <p>That's all. It is not even necessary to check for the exit from recursion, because when <code>n = 1</code> becomes, the cycles will not be executed once. It remains only to check all the resulting resistors to see if a good solution is not obtained, it is easiest to do this by cycling through all the available resistors at the beginning of the find procedure.</p>
        
        <p>What's important here. That the solution here is not built by successive additions, but that you honestly explore all possible ways. You can think of it as some kind of game in which there are positions (which resistors are on the table) and possible moves from each position, and you just iterate over such moves.</p></div>"""), {skipTree: true})

export default backtrack = (count) -> () ->
    star = if count then "" else "*"
    return {
        topic: topic(
            ruen("#{star}Рекурсивный перебор", "#{star}Recursive search"),
            ruen("#{star}Задачи на рекурсивный перебор", "#{star}Recursive search tasks"),
            [if count then null else label(ruen(
                                         "Эта тема является довольно сложной, поэтому, если вы в ней не разберетесь, то можете пропустить, и вернуться к ней на уровне 6 (там она будет обязательной). Тем не менее, рекурсивный перебор является очень полезной техникой, поэтому постарайтесь ее освоить уже сейчас.",
                                         "This topic is quite complex, so if you don't understand it, you can skip it and return to it at level 6 (it will be mandatory there). However, recursive brute force is a very useful technique, so try to master it now.")),
            label(ruen(
                "<a href=\"https://notes.algoprog.ru/backtrack/index.html\">Теория по рекурсивному перебору</a><br>\nСм. также <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">видеозаписи лекций ЛКШ параллели C'</a>, раздел «Рекурсивный перебор»",
                "<a href=\"https://notes.algoprog.ru/backtrack/index.html\">Theory of recursive iteration</a><br>\nSee also video <a href=\"https://sis.khashaev.ru/2013/august/c-prime/\">recordings of lectures of the Parallel C'</a> LCS, section \"Recursive search\"")),
            link("https://informatics.msk.ru/mod/resource/view.php?id=16016", "Красивая картинка рекурсивного дерева"),
            problem(80),
            problem(84),
            problem(85),
            problem(89),
            problem(90),
            problem(91),
            problem(485),
            problem(1182),
            ], "backtrack" + (if count then "_req" else "")),
        advancedTopics: [
            contest(ruen(
                "#{star}Продвинутые задачи на рекурсивный перебор",
                "#{star}Advanced recursive search tasks"), [
                problem(157),
                problem(1680),
                problem(2776),
                problem(3879),
                problem(3096),
                problem(158),
                problem(159),
            ]),
            module16828()
        ]
        count: count
    }