import contest from "../../lib/contest"
import label from "../../lib/label"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module25200 = () ->
    page(ruen(
        "Про задачи \"на технику\"",
        "About the tasks \"on the technique\""), ruen(
                                          String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>Задачи "на технику"</h2>
        <p>Бывают задачи, в которых вроде все понятно что делать, кажется, не надо придумывать алгоритм, нет проблем со временем работы — но тем не менее задача кажется сложной, и непонятно, с какого конца к ней подступиться (это, конечно, не строгое определение). Такие задачи принято называть задачами "на технику", часто это какие-нибудь задачи на обработку текста и т.п.</p>
        
        <p>Сложно придумать какие-нибудь универсальные рекомендации к таким задачам, но есть пара полезных соображений.</p>
        
        <p>Во-первых, такие задачи обычно имеют очень много способов их решать, но какие-то более простые в написании, а какие-то более сложные. Поэтому прежде чем бросаться писать код, надо подумать, попробовать придумать несколько разных подходов и выбрать тот, который будет проще и надежнее в реализации.</p>
        
        <p>Во-вторых, даже если сама задача выглядит сложной, зачастую ее решение можно разбить на несколько этапов, каждый из которых относительно простой. Тогда не надо пытаться написать решение одним большим циклом, который будет делать сразу все, что надо. Напишите решение, которое будет состоять из нескольких частей, каждая из которых будет по отдельности делать небольшую часть работы.</p>
        
        <p>Например, пусть вам надо обработать текст, в котором надо как-то особенно обрабатывать слова и предложения. Тогда напишите сначала код, который будет только разбивать входной текст на предложения; в результате у вас получится массив предложений. Потом напишите код, который будет брать одно предложение и разбивать его на слова. В результате у вас получится двумерный массив слов: каждая строка массива — это слова одного предложения. И уже потом пишите то, что надо по условию задачи.</p>
        
        <p>Или, еще лучше — напишите функцию, которая будет принимать на вход одно предложение и будет его как надо обрабатывать. И тогда в основном коде вам не нужен будет двумерный массив, вы просто будете разбивать текст на предложения и по одному скармливать их этой функции, а в результате внутри функции вы имеете дело только с одним предложением. Если вам надо как-то особо обрабатывать слова, то напишите еще одну функцию, которая обрабатывает одно слово, и вызывайте ее из функции, обрабатывающей предложение.</p>
        
        <p>Чуть более подробный пример (я уже где-то про это писал) — пусть вам дан текст, надо нормализовать заглавные буквы (после точек сделать заглавные буквы, а в остальных местах — маленькие), убрать двойные пробелы, добавить пробелы после знаков препинания, и вывести, перенося слова так, чтобы каждая строка была не длиннее 80 символов — то не надо тоже бросаться все делать сразу. Напишите программу, которая сначала нормализует заглавные буквы. Потом уберет двойные пробелы. Потом добавит пробелы где надо (может быть, это будет удобно совместить с предыдущим или со следующим пунктом, тут можно по-разному организовать код, это уже зависит от конкретных деталей задачи). Потом разобьет текст на слова. Потом уже выведет текст разбитым на строки так, как надо.</p>
        
        <p>Еще пример — пусть вам надо вычислить значение многочлена, т.е. дана строка вида <code>2*x^2+3*x+5</code>, и значение <code>x</code>, надо вычислить значение многочлена. Это не так сложно, как кажется, надо просто сначала разбить строку-многочлен на слагаемые, потом в каждом слагаемом отдельно выделить коэффициент и степень, и дальше уже все просто считается.</p>
        
        <p>Вообще, общий принцип такой: старайтесь писать код так, чтобы <b>в каждом месте программы вам надо было держать в голове как можно меньше информации</b>. И в плане тех данных и переменных, которые вы используете, и в плане тех требований, которые вам надо выполнять. Если вы понимаете, что одна переменная вам нужна в одном месте кода, а другая — в другом — то подумайте, нельзя ли разнести код так, чтобы в первом месте вам не надо было думать про вторую переменную, и т.п.</p>
        
        <hr>
        
        <p>Мелкий комментарий на эту же тему, хотя и не относящийся явно к задачам на технику. Пусть, например, вам в программе надо считать суммы элементов в строках двумерного массива:
        </p><table border="1" cellpadding="5">
        <tbody><tr><td>Паскаль</td><td>Питон</td></tr>
        <tr><td><pre>var a:array[1..100,1..100] of integer;
            s:integer;
        ...
        for i:=1 to n do begin
            s:=0;
            for j:=1 to m do
                s:=s+a[i,j];
            ... что-то делаем с s
            ... делаем что-то еще
        end;
        ...
        </pre></td>
        <td><pre># a -- двумерный массив
        for i in range(n):
            s = 0
            for j in range(m):
                s += a[i][j]
            ... что-то делаем с s
            ... делаем что-то еще
        ...
        </pre>
        </td></tr></tbody></table>
        <p>Можно писать так, как написано выше. А можно так — и многие из вас именно так и пишут:
        </p><table border="1" cellpadding="5">
        <tbody><tr><td>Паскаль</td><td>Питон</td></tr>
        <tr><td><pre>var a:array[1..100,1..100] of integer;
            s:integer;
        ...
        s:=0;
        for i:=1 to n do begin
            for j:=1 to m do
                s:=s+a[i,j];
            ... что-то делаем с s
            ... делаем что-то еще
            s:=0;
        end;
        ...
        </pre></td>
        <td><pre># a -- двумерный массив
        s = 0
        for i in range(n):
            for j in range(m):
                s += a[i][j]
            ... что-то делаем с s
            ... делаем что-то еще
            s = 0
        ...
        </pre>
        </td></tr></tbody></table>
        <p>Отличие в том, что в первом коде вы зануляете переменную <code>s</code> <i>перед</i> использованием, а во втором коде — после.</p>
        
        <p>Так вот, настоятельно вам рекомендую писать именно так, как в первом варианте. Потому что во втором варианте вам надо помнить, что <code>s</code> должно быть равно нулю в конце итерации цикла, а в первом варианте — нет. В первом варианте вас вообще не волнует, чему равна <code>s</code> на входе в цикл, и чему она равна в конце цикла. В первом варианте, можно сказать, вся жизнь переменной <code>s</code> ограничена тремя строками кода, вам не надо помнить и думать про нее за пределами этих трех строк. Поэтому в первом варианте вам надо меньше думать и меньше помнить, поэтому он проще и надежнее.</p>
        
        <p>Элементарный пример, как может что-то пойти не так во втором варианте — пусть вы где-то внутри цикла по <code>i</code> решили написать <code>continue</code>. И все, у вас пропустилось присваивание <code>s=0</code>.</p></div>""",
                                          String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>Tasks "for equipment"</h2>
        <p>There are tasks in which everything seems to be clear what to do, it seems that there is no need to invent an algorithm, there are no problems with work time — but nevertheless the task seems difficult, and it is unclear from which end to approach it (this, of course, is not a strict definition). Such tasks are commonly called "technique" tasks, often they are some kind of text processing tasks, etc.</p>
        
        <p>It is difficult to come up with any universal recommendations for such tasks, but there are a couple of useful considerations.</p>
        
        <p>Firstly, such tasks usually have a lot of ways to solve them, but some are easier to write, and some are more complex. Therefore, before rushing to write code, you need to think, try to come up with several different approaches and choose the one that will be easier and more reliable to implement.</p>
        
        <p>Secondly, even if the task itself looks complicated, its solution can often be divided into several stages, each of which is relatively simple. Then you don't have to try to write a solution in one big loop that will do everything you need at once. Write a solution that will consist of several parts, each of which will individually do a small part of the work.</p>
        
        <p>For example, suppose you need to process a text in which you need to process words and sentences in some special way. Then first write a code that will only split the input text into sentences; as a result, you will get an array of sentences. Then write a code that will take one sentence and break it into words. As a result, you will get a two—dimensional array of words: each row of the array is the words of one sentence. And only then write what is necessary according to the condition of the task.</p>
        
        <p>Or, even better, write a function that will accept one sentence as input and will process it properly. And then in the main code you will not need a two-dimensional array, you will just split the text into sentences and feed them to this function one by one, and as a result, inside the function you are dealing with only one sentence. If you need to process words in a special way, then write another function that processes one word, and call it from the function that processes the sentence.</p>
        
        <p>A slightly more detailed example (I've already written about it somewhere) — let the text be given to you, it is necessary to normalize capital letters (make capital letters after dots, and small ones in other places), remove double spaces, add spaces after punctuation marks, and output, transferring words so that each line is no longer than 80 characters — then you don't have to rush to do everything at once, too. Write a program that first normalizes capital letters. Then it will remove the double spaces. Then he will add spaces where necessary (maybe it will be convenient to combine it with the previous or the next item, here you can organize the code in different ways, it already depends on the specific details of the task). Then it will break the text into words. Then it will output the text divided into lines as it should.</p>
        
        <p>Another example — let you need to calculate the value of the polynomial, i.e. given a string of the form <code>2*x^2+3*x+5</code>, and the value of <code>x</code>, you need to calculate the value of the polynomial. It's not as difficult as it seems, you just need to first split the polynomial string into terms, then separate the coefficient and degree in each term, and then everything is just counted.</p>
        
        <p>In general, the general principle is this: try to write code so that <b>in each place of the program you need to keep as little information in your head as possible</b>. Both in terms of the data and variables that you use, and in terms of the requirements that you need to fulfill. If you understand that you need one variable in one place of the code, and the other in another, then think about whether it is possible to spread the code so that you don't have to think about the second variable in the first place, etc.</p>
        
        <hr>
        
        <p>A small comment on the same topic, although not explicitly related to the tasks of the technique. Suppose, for example, you need to count the sums of elements in the rows of a two-dimensional array in the program:
        </p><table border="1" cellpadding="5">
        <tbody><tr><td>Pascal</td><td>Python</td></tr>
        <tr><td><pre>var a:array[1..100,1..100] of integer;
            s:integer;
        ...
        for i:=1 to n do begin
            s:=0;
            for j:=1 to m do
                s:=s+a[i,j];
            ... doing something with s
            ... doing something else
        end;
        ...
        </pre></td>
        <td><pre># a -- two-dimensional array
        for i in range(n):
            s = 0
            for j in range(m):
                s += a[i][j]
            ... doing something with s
            ... doing something else
        ...
        </pre>
        </td></tr></tbody></table>
        <p>You can write as it is written above. Or you can do it like that — and many of you write exactly like that:
        </p><table border="1" cellpadding="5">
        <tbody><tr><td>Pascal</td><td>Python</td></tr>
        <tr><td><pre>var a:array[1..100,1..100] of integer;
            s:integer;
        ...
        s:=0;
        for i:=1 to n do begin
            for j:=1 to m do
                s:=s+a[i,j];
            ... doing something with s
            ... doing something else
            s:=0;
        end;
        ...
        </pre></td>
        <td><pre># a -- two-dimensional array
        s = 0
        for i in range(n):
            for j in range(m):
                s += a[i][j]
            ... doing something with s
            ... doing something else
            s = 0
        ...
        </pre>
        </td></tr></tbody></table>
        <p>The difference is that in the first code you will take the variable <code>s</code> <i>before</i> use, and in the second code — after.</p>
        
        <p>So, I strongly recommend that you write exactly as in the first version. Because in the second option, you need to remember that <code>s</code> should be zero at the end of the loop iteration, but not in the first option. In the first variant, you don't care at all what <code>s</code> is equal to at the entrance to the loop, and what it is equal to at the end of the loop. In the first variant, we can say that the whole life of the variable <code>s</code> is limited to three lines of code, you do not need to remember and think about it outside of these three lines. Therefore, in the first option, you need to think less and remember less, so it is simpler and more reliable.</p>
        
        <p>An elementary example of how something can go wrong in the second option - let you decide to write <code>continue</code> somewhere inside the <code>i</code> loop. And that's it, you missed the assignment <code>s=0</code>.</p></div>"""), {skipTree: true})

module25629 = () ->
    page(ruen(
        "Разбор задачи \"Смайлики\", читать только тем, кто решил",
        "Analysis of the task \"Emoticons\", read only to those who have solved"), ruen(
                                                                         String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><p style="margin-bottom: 100px">Разбор задачи "Смайлики", читать только тем, кто решил!</p>
        
        <p>Во-первых, в этой задаче надо правильно понять условие, например, понять, что на тест <code>;:-()[]</code> ответ 1, т.к. эта строка содержит один смайлик — <code>:-(</code>. Т.е. не страшно, если вокруг смайлика есть лишние символы, важно, что сам смайлик можно выделить.</p>
        
        <p>Дальше эту задачу можно решать по-разному. Можно, конечно, идти по строке, искать двоеточие или точку с запятой, после нее искать минусы, после нее — одинаковые скобки. Это можно написать, но это не очень просто (хотя и не суперсложно).</p>
        
        <p>Можно немного упростить решение, поняв, что не надо искать <i>много</i> одинаковых скобок, хватит и одной, т.к. если есть смайлик с кучей скобок, то если убрать все скобки, кроме последней, то он тоже останется смайликом.</p>
        
        <p>Но можно и еще более упростить решение, сделав одно простое наблюдение. <b>Если выкинуть из входного файла все минусы, то ответ не изменится!</b> Действительно, смайлик без минусов — это тоже смайлик, и наоборот, если в смайлик без минусов вставить минусы, то получится все равно смайлик. Поэтому от выкидывания минусов не появится новых смайликов, а старые не пропадут.</p>
        
        <p>Поэтому очень простое решение этой задачи — выкинем все минусы, а после этого посчитаем, сколько в строке встречается пар соседних символов таких, что первый из них — это : или ;, а второй — скобка.</p>
        </div>""",
                                                                         String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><p style="margin-bottom: 100px">Analysis of the task "Emoticons", read only to those who have decided!</p>
        
        <p>First, in this task it is necessary to understand the condition correctly, for example, to understand that the test<code>;:-()[]</code> answer is 1, because this line contains one smiley — <code>:-(</code>. I.e. it's not scary if there are extra characters around the smiley, it's important that the smiley itself can be highlighted.</p>
        
        <p>Then this task can be solved in different ways. You can, of course, go along the line, look for a colon or semicolon, look for cons after it, after it — the same brackets. It can be written, but it's not very simple (although not super complicated).</p>
        
        <p>You can simplify the solution a little by realizing that you don't need to look for <i>many</i> identical brackets, one is enough, because if there is a smiley with a bunch of brackets, then if you remove all the brackets except the last one, then it will also remain a smiley.</p>
        
        <p>But you can also simplify the solution even more by making one simple observation. <b>If you remove all the disadvantages from the input file, the answer will not change!</b> Indeed, a smiley face without minuses is also a smiley face, and vice versa, if you insert minuses into a smiley face without minuses, you will still get a smiley face. Therefore, no new emoticons will appear from throwing out the minuses, and the old ones will not disappear.</p>
        
        <p>Therefore, a very simple solution to this problem is to throw out all the disadvantages, and then calculate how many pairs of adjacent characters occur in a string such that the first of them is : or ;, and the second is a bracket.</p>
        </div>"""), {skipTree: true})

export default technical = () ->
    return {
        topics: [topic("Задачи \"на технику\"", "Задачи \"на технику\"", [
                module25200(),
                problem(848),
                problem(426),
                problem(1629),
            ], "technical"),
            module25629()
        ],
        advancedproblems: [
            problem(1026),
            problem(3183),
            problem(1230),
        ]
    }
