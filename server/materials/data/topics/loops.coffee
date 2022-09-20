import contest from "../../lib/contest"
import label from "../../lib/label"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module15969 = () ->
    page(ruen(
        "Про оформление программ и отступы (про паскаль, но в питоне и c++ все то же самое)",
        "About program layout and indents (about Pascal, but in python and c++ everything is the same)"), ruen(
                                                                                                   String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Оформление программ и отступы</h1>
        <h2>Общие замечания</h2>
        <p>Паскаль, как и многие другие языки программирования, допускает достаточно свободное оформление программ. Вы можете ставить пробелы и переводы строк как вам угодно (за исключением, конечно, ряда понятных требований типа пробелов в выражении <font face="courier">if a mod b=c then</font>).</p><p>
        
        </p><p>Тем не менее, следует придерживаться определенных правил — не для того, чтобы программа компилировалась, а для того, чтобы программу было бы легче читать человеку. Это важно и в ситуации, когда вашу программу будет читать кто-то другой, так и в ситуации, когда вашу программу будете читать <i>вы сами</i>. В хорошо отформатированной программе легче находить другие ошибки компиляциии, легче находить логические ошибки в коде, такую программу легче дописывать и модифицировать и так далее.</p>
        
        <p>Основная цель форматирования программы — чтобы была лучше видна ее структура, то есть чтобы были лучше видны циклы, if'ы и прочие конструкции, важные для понимания последовательности выполнения действий. Должно быть легко понять, какие команды в каком порядке выполняются в программе, и в первую очередь — какие команды относятся к каким циклам и if'ам (циклы, if'ы и подобные конструкции ниже я буду называть управляющими конструкциями).</p>
        
        <p>Поэтому следует придерживаться некоторых правил. Есть множество разных стандартов, правил на эту тему; во многих проектах, которые пишут целые команды программистов, есть официально требования, и каждый программист обязан их соблюдать вплоть до пробела. На наших занятиях я не буду столь строго относиться к оформлению, но тем не менее я буду требовать соблюдения ряда правил (это — некоторая "выжимка", то общее, что есть практически во всех стандартах), а также буду настоятельно рекомендовать соблюдать еще ряд правил.</p>
        
        <p>Разделы ниже будут пополняться по мере того, как я что-то буду вспоминать или видеть в ваших программах.</p>
        
        <h2>Обязательные требования</h2>
        <ul>
        <li>Используйте здравый смысл. Любое из указанных ниже правил можно нарушать, если здравый смысл подсказывает вам, что лучше сделать не так — но такие ситуации скорее исключение, чем правило.</li>
        <li>На каждой строке должно быть не более одной команды и/или управляющей конструкции.
        <ul><li>Исключение: очень тесно связанные между собой по смыслу команды типа assign и reset.</li>
        <li>Исключение: управляющая конструкция, внутри которой находится только одна короткая команда, например:
        <pre>if a&gt;0 then inc(i);
        </pre>
        </li>
        <li>Исключение: цикл for со вложенным if'ом, имеющий смысл "пройти только по элементам, удовлетворяющим условию":
        <pre>for i:=a to b do if x[i]&lt;&gt;0 then begin // больше кода тут быть не должно!
        </pre>
        </li>
        </ul>
        </li>
        <li>В коде должны быть отступы — некоторые строки должны быть написаны не вплотную к левому краю, а с несколькими пробелами вначале:
        <pre>if a=0 then begin
           b:=2;  // в этой строке отступ
           c:=c+2; // и в этой тоже
        end;
        </pre>
        Основной принцип отступов — программу можно представить себе как последовательность вложенных блоков. Основной блок — сама программа. В нем могут быть простые команды, а также сложные блоки — if'ы, циклы и т.д. Код внутри if'а или внутри цикла — это отдельный блок, вложенный в основной блок. Код внутри цикла внутри if'а — это блок, вложенный в другой блок, вложенный в третий. Пример: следующему коду:
        <pre>read(n);
        for i:=1 to n do begin
          read(a[i]);
          if a[i]&gt;0 then begin
            writeln(a[i]);
            k:=k+1;
          end;
        end;
        if n&gt;0 then 
          writeln('!');
        </pre> 
        соответствует следующая структура блоков:
        <pre>+--------------------+
        | основная программа |
        | +-----------+      |
        | | цикл for  |      |
        | | +-------+ |      |
        | | | if    | |      |
        | | +-------+ |      |
        | +-----------+      |
        | +------+           |
        | | if   |           |
        | +------+           |
        +--------------------+
        </pre>
        Так вот, в пределах одного блока отступ должен быть один и тот же. А для каждого внутреннего блока отступ должен быть увеличен. (При этом заголовок цикла или if'а считается частью внешнего блока и пишется без отступа.)</li>
        <li>То же самое можно сказать по-другому: внутренний код управляющей конструкции должен быть написан с отступом. Если в одну управляющую конструкцию вложена другая, то отступ у внутреннего кода должен быть удвоен, и т.д. В результате все команды, которые всегда выполняются одна за другой, должны идти с одним отступом (их первые символы должны идти один под другим), а если где-то порядок может меняться, отступы должны быть разные.<br>
        Придерживайтесь одинакового размера "базового" отступа везде в программе, обычно его берут 2 или 4 пробела. Один пробел — слишком мало.<br>
        Пример отступов:
        <pre>for i:=1 to n do begin
            read(a); // вошли внутрь for --- появился отступ: 4 пробела
            if a&lt;&gt;0 then begin 
                inc(m); // вошли еще и внутрь if --- отступ стал в два раза больше
                b[m]:=a;
            end;
        end;
        for i:=1 to m do
            writeln(b[i]); // если выше единичный отступ был 4 пробела, то и здесь тоже 4, а не 2!
        </pre></li>
        <li>Элементы, обозначающие окончание части или всей управляющей конструкции (else и/или end) должны находиться на отдельных строках и на том же уровне отступа, что и начало управляющей конструкции. (К begin это не относится, т.к. начало управляющей конструкции видно и так.)<br>
        Примеры:<br>
        <font color="red">Неправильно:
        <pre>for i:=1 to n do begin
            read(a);
            s:=s+a; end;      // end очень плохо заметен
        if s&gt;2 then 
            writeln(s) 
            else begin         // else очень плохо заметен
            writeln('Error');
            halt;
            end;               // end плохо заметен
        </pre></font>
        <font color="green">Правильно:
        <pre>for i:=1 to n do begin
            read(a);
            s:=s+a; 
        end;                  // end сразу виден
        if s&gt;2 then
            writeln(s) 
        else begin            // else сразу виден и разрывает последовательность строк: 
            writeln('Error');  // видно, что это две ветки
            halt;
        end;                  // видно, что end есть и не потерян
        </pre></font>
        Допускается размещать фразу <font face="courier">end else begin</font> на одной строке.</li>
        <li>Бывает так, что у вас идет целая цепочка конструкций if, разбирающая несколько случаев:
        <pre>if dir='North' then
            ...
        else if dir='South' then
            ...
        else if dir='East' then
            ...
        else if dir='West' then
            ...
        else
            writeln('Error!');
        </pre>
        По смыслу программы это — многовариантное ветвление, здесь все случаи равноправны или почти равноправны. Тот факт, что в программе каждый следующий if вложен в предыдущий — это просто следствие того, что в паскале нет возможности сделать многовариантное ветвление. Поэтому такой код надо оформлять именно так, как указано выше, т.е. все ветки <font face="courier">else if</font> делать на одном отступе. (Не говоря уж о том, что если на каждый такой if увеличивать отступ, то программа очень сильно уедет вправо.)<br>
        Но отличайте это от слудеющего варианта:
        <pre>if a=0 then 
            writeln(-1);
        else begin
            if b=0 then
                x:=1;
            else
                x:=b/a;
            writeln(x);
        end;
        </pre>
        Здесь варианты <code>if a=0</code> и <code>if b=0</code> не равноправны: вариант <code>b=0</code> явно вложен внутрь <code>else</code>.
        
        </li><li>Команды, выполняющиеся последовательно, должны иметь один и тот же оступ.
        Примеры:<br>
        <font color="red">Неправильно:
        <pre> read(a);
           b:=0;
          c:=0;
        for i:=1 to a do begin
              b:=b+i*i;
            c:=c+i;
         end;
        </pre></font>
        <font color="red">Все равно неправильно (for всегда выполняется после c:=0, поэтому отступы должны быть одинаковыми):
        <pre>   read(a);
           b:=0;
           c:=0;
        for i:=1 to a do begin 
              b:=b+i*i;
              c:=c+i;
        end;
        </pre></font>
        <font color="green">Правильно:
        <pre>read(a);
        b:=0;
        c:=0;
        for i:=1 to a do begin 
            b:=b+i*i;
            c:=c+i;
        end;
        </pre></font>
        </li>
        <li>Не следует без необходимости переносить на новую строку части заголовка управляющих конструкций (условия в if, while, repeat; присваивание в заголовке for; параметры процедур и т.д.). С другой стороны, если заголовок управляющей конструкции получается слишком длинным, то перенести можно, но тогда перенесенная часть должна быть написана с отступом, и вообще форматирование должно быть таким, чтобы было четко видно, где заканчивается заголовок управляющей конструкции, и хорошо бы выделить структуру заголовка (парные скобки в условии и т.п.)<br>
        Примеры:<br>
        <font color="red">Неправильно:
        <pre>if
        a=0 then // условие короткое, лучше в одну строку
        ...
        for 
           i:=1
           to 10 do // аналогично
        ...
        {слишком длинно --- лучше разбить}
        if (((sum+min=min2+min3) or (sqrt(sumSqr)&lt;30)) and (abs(set1-set2)+eps&gt;thershold)) or (data[length(s)-i+1]=data[i]) or good then...</pre></font>
        <font color="green">Правильно:
        <pre>if a=0 then
        ...
        for i:=1 to 10 do
        ...
        {четко видно, где заканчивается условие, плюс выделены парные скобки}
        if (
              ( (sum+min=min2+min3) or (sqrt(sumSqr)&lt;30) ) and (abs(set1-set2)+eps&gt;thershold)
            ) or (data[length(s)-i+1]=data[i]) or good
        then...</pre></font>
        
        </li><li>В секции <font face="courier">var</font> все строчки должны быть выровнены так, чтобы первая буква первой переменной в каждой строке были бы одна под другой; это обозначает, что у второй и далее строк должен быть отступ 4 пробела. Аналогично в остальных секциях, идущих до кода, (<font face="courier">type</font>, <font face="courier">const</font> и т.д.) надо все строки варавнивать по первому символу:
        <pre>type int=integer;
             float=extended;
        var i:integer;
            s:string;
        </pre>
        </li><li>Разделяйте процедуры/функции друг от друга и от основного текста пустой строкой (или двумя); используйте также пустые строки внутри длинного программного текста, чтобы разбить его на логически связные блоки.</li>
        </ul>
        <h2>Не столь обязательные требования, но которые я настоятельно рекомендую соблюдать</h2>
        <ul>
        <li>Пишите <font face="courier">begin</font> на той же строке, что и управляющая конструкция, ну или хотя бы на том же отступе, что и управляющая конструкция:<br>
        <font color="red">Совсем плохо:
        <pre>for i:=1 to n do
            begin
            read(a[i]);
            ...
        </pre>
        </font>
        <font color="#555500">Более-менее:
        <pre>for i:=1 to n do
        begin
            read(a[i]);
            ...
        </pre></font>
        <font color="green">Еще лучше:
        <pre>for i:=1 to n do begin
            read(a[i]);
            ...
        </pre></font>
        </li>
        </ul>
        <h2>Пример хорошо отформатированной программы:</h2>
        <pre>function sum(a, b: longint): longint;
        begin
          sum := a + b;
        end;
         
        var i, a, b, s: longint;
            x, y: double;
            arr: array [1..1000] of boolean;
         
        begin
        read(a, b);
         
        arr[1] := true;
         
        for i := 2 to 1000 do
          if ((a &gt; 0) and (arr[i-1])) then
            arr[i] := true;
         
        for i := 1 to 1000 do
          arr[i] := false;
         
        s := 0;
        if (a &lt; 0) then begin
          a := -a;
          if (b &lt; 0) then begin
            b := -b;
            s := a + b;
          end else begin
            while (s &lt;= 0) do begin
              case a of
                1: begin
                  s := s + 3;
                end;
                2: begin
                  s := s - 4;
                  a := a - 1;
                end;
                else
                  s := 1;
              end;
            end;
          end;
        end else if (b &lt; 0) then begin
          b := -b;
          s := (a + b) * (a - b);
        end else begin
          s := sum(a, b) * sum(a, b);
        end;
            
        writeln(s);
        end.
        </pre></div>""",
                                                                                                   String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Program layout and margins</h1>
                <h2>General remarks</h2>
        <p>Pascal, like many other programming languages, allows for a fairly free design of programs. You can put spaces and line feeds as you like (except, of course, for a number of understandable requirements such as spaces in the expression <font face="courier">if a mod b=c then</font>).</p><p>

        </p><p>Nevertheless, certain rules should be followed — not so that the program is compiled, but so that the program would be easier for a person to read. This is important both in a situation when your program will be read by someone else, and in a situation when your program will be read by <i>yourself</i>. In a well-formatted program, it is easier to find other compilation errors, it is easier to find logical errors in the code, it is easier to add and modify such a program, and so on.</p>

        <p>The main purpose of formatting a program is to make its structure better visible, that is, to make loops, if's and other constructions that are important for understanding the sequence of actions better visible. It should be easy to understand which commands are executed in what order in the program, and first of all, which commands relate to which cycles and if's (cycles, if's and similar constructions below I will call control constructions).</p>

        <p>Therefore, some rules should be followed. There are many different standards and rules on this topic; in many projects that are written by entire teams of programmers, there are official requirements, and each programmer is obliged to comply with them up to a space. In our classes, I will not be so strict about the design, but nevertheless I will demand compliance with a number of rules (this is some kind of "squeeze", that is common to almost all standards), and I will also strongly recommend following a number of rules.</p>

        <p>The sections below will be updated as I remember something or see something in your programs.</p>

        <h2>Mandatory requirements</h2>
        <ul>
        <li>Use common sense. Any of the rules listed below can be violated if common sense tells you what is better to do wrong — but such situations are the exception rather than the rule.</li>
        <li>There should be no more than one command and/or control structure on each line.
        <ul><li>Exception: very closely related commands like assign and reset.</li>
        <li>Exception: a control structure with only one short command inside, for example:
        <pre>if a&gt;0 then inc(i);
        </pre>
        </li>
        <li>Exception: a for loop with a nested if, which makes sense to "pass only through elements that satisfy the condition":
        <pre>for i:=a to b do if x[i]&lt;&gt;0 then begin // there should be no more code here!
        </pre>
        </li>
        </ul>
        </li>
        <li>There should be indents in the code — some lines should not be written close to the left edge, but with a few spaces at the beginning:
        <pre>if a=0 then begin
            b:=2; // indent in this line
            c:=c+2; // and in this one too
        end;
        </pre>
        The basic principle of indentation is that the program can be imagined as a sequence of nested blocks. The main block is the program itself. It can contain simple commands, as well as complex blocks — if's, loops, etc. The code inside an if or inside a loop is a separate block nested in the main block. The code inside the loop inside an if is a block nested in another block nested in a third. Example: the following code:
        <pre>read(n);
        for i:=1 to n do begin
            read(a[i]);
            if a[i]&gt;0 then begin
                writeln(a[i]);
                k:=k+1;
            end;
        end;
        if n&gt;0 then
            writeln('!');
        </pre>
        the following block structure corresponds:
        <pre>
        +--------------------+
        | main program       |
        | +-----------+      |
        | | for loop  |      |
        | | +-------+ |      |
        | | | if    | |      |
        | | +-------+ |      |
        | +-----------+      |
        | +------+           |
        | | if   |           |
        | +------+           |
        +--------------------+
        </pre>
        So, within one block, the indentation should be the same. And for each indoor unit, the indentation should be increased. (In this case, the loop or if header is considered part of the outer block and is written without indentation.)</li>
        <li>The same can be said in another way: the internal code of the control structure must be indented. If another control structure is embedded in one, then the indentation of the internal code should be doubled, etc. As a result, all commands that are always executed one after the other must be indented (their first characters must go one under the other), and if the order can change somewhere, the indents must be different.<br>
        Stick to the same size of the "base" indentation everywhere in the program, usually 2 or 4 spaces take it. One space is too little.<br>
        Example of margins:
        <pre>for i:=1 to n do begin
            read(a); // went inside for --- indentation appeared: 4 spaces
            if a&lt;&gt;0 then begin
                inc(m); // they also entered inside if --- the indentation became twice as large
                b[m]:=a;
            end;
        end;
        for i:=1 to m do
            writeln(b[i]); // if the unit indentation above was 4 spaces, then here, too, 4, not 2!
        </pre></li>
        <li>The elements indicating the end of part or all of the control structure (else and/or end) must be on separate lines and at the same indentation level as the beginning of the control structure. (This does not apply to begin, because the beginning of the control structure is visible and so.)<br>
        Examples:<br>
        <font color="red">Incorrect:
        <pre>for i:=1 to n do begin
            read(a);
            s:=s+a; end; // end is very poorly visible
        if s&gt;2 then
            writeln(s)
            else begin // else is very poorly visible
            writeln('Error');
            halt;
            end; // end is poorly visible
        </pre></font>
        <font color="green">Correct:
        <pre>for i:=1 to n do begin
            read(a);
            s:=s+a;
        end; // end is immediately visible
        if s&gt;2 then
            writeln(s)
        else begin // else is immediately visible and breaks the sequence of lines:
            writeln('Error'); // it is clear that these are two branches
            halt;
        end; // it can be seen that the end is there and is not lost
        </pre></font>
        It is allowed to place the phrase <font face="courier">end else begin</font> on one line.</li>
        <li>It happens that you have a whole chain of if constructs that analyzes several cases:
        <pre>if dir='North' then
            ...
        else if dir='South' then
            ...
        else if dir='East' then
            ...
        else if dir='West' then
            ...
        else
            writeln('Error!');
        </pre>
        According to the meaning of the program, this is a multivariate branching, here all cases are equal or almost equal. The fact that in the program each subsequent if is nested in the previous one is simply a consequence of the fact that there is no way to do multivariate branching in pascal. Therefore, such code should be designed exactly as indicated above, i.e. all branches of <font face="courier">else if</font> should be done on one indent. (Not to mention the fact that if you increase the indentation for each such if, the program will go very much to the right.)<br>
        But distinguish this from the following case:
        <pre>if a=0 then
            writeln(-1);
        else begin
            if b=0 then
                x:=1;
            else 
                x:=b/a;
            writeln(x);
        end;
        </pre>
        Here the options <code>if a=0</code> and <code>if b=0</code> are not equal: the option <code>b=0</code> is explicitly nested inside <code>else</code>.

        </li><li>Commands executed sequentially must have the same stumble.
        Examples:<br>
        <font color="red">Incorrect:
        <pre> read(a);
           b:=0;
          c:=0;
        for i:=1 to a do begin
              b:=b+i*i;
            c:=c+i;
         end;
        </pre></font>
        <font color="red">Still wrong (for is always executed after c:=0, so the margins should be the same):
        <pre>   read(a);
           b:=0;
           c:=0;
        for i:=1 to a do begin 
              b:=b+i*i;
              c:=c+i;
        end;
        </pre></font>
        <font color="green">Correct:
        <pre>read(a);
        b:=0;
        c:=0;
        for i:=1 to a do begin 
            b:=b+i*i;
            c:=c+i;
        end;
        </pre></font>
        </li>
        <li>You should not unnecessarily move parts of the header of control structures to a new line (conditions in if, while, repeat; assignment in the for header; procedure parameters, etc.). On the other hand, if the header of the control structure turns out to be too long, then you can move it, but then the transferred part should be indented, and in general formatting should be such that it is clearly visible where the header of the control structure ends, and it would be good to highlight the header structure (paired brackets in the condition, etc.)<br>
        Examples:<br>
        <font color="red">Incorrect:
        <pre>if
        a=0 then // the condition is short, preferably in one line
        ...
        for
          i:=1
          to 10 do // similarly
        ...
        {too long --- better split}
        if (((sum+min=min2+min3) or (sqrt(sumSqr)&lt;30)) and (abs(set1-set2)+eps&gt;thershold)) or (data[length(s)-i+1]=data[i]) or good then...</pre></font>
        <font color="green">Correct:
        <pre>if a=0 then
        ...
        for i:=1 to 10 do
        ...
        {it is clearly visible where the condition ends, plus paired brackets are highlighted}
        if (
              ( (sum+min=min2+min3) or (sqrt(sumSqr)&lt;30) ) and (abs(set1-set2)+eps&gt;thershold)
            ) or (data[length(s)-i+1]=data[i]) or good
        then...</pre></font>

        </li><li>In the section <font face="courier">var</font>, all lines should be aligned so that the first letter of the first variable in each line would be one under the other; this means that the second and further lines should be indented with 4 spaces. Similarly, in the other sections going up to the code (<font face="courier">type</font>, <font face="courier">const</font>, etc.), all lines must be equalized by the first character:
        <pre>type int=integer;
             float=extended;
        var i:integer;
            s:string;
        </pre>
        </li><li>Separate procedures/functions from each other and from the main text with an empty line (or two); also use empty lines inside a long program text to break it into logically coherent blocks.</li>
        </ul>
        <h2>Not so mandatory requirements, but which I strongly recommend following</h2>
        <ul>
        <li>Write <font face="courier">begin</font> on the same line as the control structure, or at least on the same indentation as the control structure:<br>
        <font color="red">Very bad:
        <pre>for i:=1 to n do
            begin
            read(a[i]);
            ...
        </pre>
        </font>
        <font color="#555500">Better:
        <pre>for i:=1 to n do
        begin
            read(a[i]);
            ...
        </pre></font>
        <font color="green">Even better:
        <pre>for i:=1 to n do begin
            read(a[i]);
            ...
        </pre></font>
        </li>
        </ul>
        <h2>Example of a well-formatted program:</h2>
        <pre>function sum(a, b: longint): longint;
        begin
          sum := a + b;
        end;
         
        var i, a, b, s: longint;
            x, y: double;
            arr: array [1..1000] of boolean;
         
        begin
        read(a, b);
         
        arr[1] := true;
         
        for i := 2 to 1000 do
          if ((a &gt; 0) and (arr[i-1])) then
            arr[i] := true;
         
        for i := 1 to 1000 do
          arr[i] := false;
         
        s := 0;
        if (a &lt; 0) then begin
          a := -a;
          if (b &lt; 0) then begin
            b := -b;
            s := a + b;
          end else begin
            while (s &lt;= 0) do begin
              case a of
                1: begin
                  s := s + 3;
                end;
                2: begin
                  s := s - 4;
                  a := a - 1;
                end;
                else
                  s := 1;
              end;
            end;
          end;
        end else if (b &lt; 0) then begin
          b := -b;
          s := (a + b) * (a - b);
        end else begin
          s := sum(a, b) * sum(a, b);
        end;
            
        writeln(s);
        end.
        </pre></div>"""), {skipTree: true})

export default loops = () ->
    return {
        topic: topic(
            ruen("Циклы", "Loops"),
            ruen("Задачи на циклы", "Problems on loops"),
        [label(ruen(
                   String.raw"""<a href="https://notes.algoprog.ru/python_basics/2_loops.html">Теория про циклы</a><br>
                Внутри теории про циклы есть также раздел <a href="https://notes.algoprog.ru/python_basics/2_loops.html#break-continue">про команды break и continue</a>.
                Прочитайте его, даже если вы пишете не на питоне, в других языках все аналогично.""",
                   String.raw"""<a href="https://notes.algoprog.ru/en/python_basics/2_loops.html">Theory on loops</a><br>
                Inside the theory on loops there is also a section <a href="https://notes.algoprog.ru/en/python_basics/2_loops.html#break-continue">about the break and continue commands</a>.
                Read it, even if you don't write in python, everything is the same in other languages.""")),
            module15969(),
            problem({testSystem: "ejudge", contest: "3005", problem: "1", id: "333"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "2", id: "351"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "3", id: "315"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "4", id: "340"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "5", id: "347"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "6", id: "113"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "7", id: "3058"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "8", id: "3064"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "9", id: "3065"}),
            problem({testSystem: "ejudge", contest: "3005", problem: "10", id: "3067"}),
        ], "loops"),
        advancedTopics: [
            label(ruen(
                "Если вы пишете на питоне, то в первых двух задачах из продвинутых задач на циклы массивами пользоваться можно — просто потому, что иначе вы не сможете считать много чисел в одной строке.",
                "If you write in python, then you can use arrays in the first two advanced problems on loops \u2014 simply because otherwise you will not be able to count many numbers in one line.")),
            contest(ruen(
                "Продвинутые задачи на циклы: в них запрещается пользоваться массивами",
                "Advanced problems on loops: it is forbidden to use arrays here"), [
                problem({testSystem: "ejudge", contest: "3011", problem: "1", id: "227"}),
                problem({testSystem: "ejudge", contest: "3011", problem: "2", id: "228"}),
                problem({testSystem: "ejudge", contest: "3011", problem: "3", id: "3072"}),
                problem({testSystem: "ejudge", contest: "3011", problem: "4", id: "3077"}),
                problem({testSystem: "ejudge", contest: "3011", problem: "5", id: "1430"}),
            ])
        ]
    }