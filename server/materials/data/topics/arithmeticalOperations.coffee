import label from "../../lib/label"
import page  from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module25368 = () ->
    page("Про \"странные числа\" в коде", ruen(
                                              String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Про "странные числа" в коде</h1>
        <p>Иногда в ваших программах вам может быть нужно использовать какие-то фиксированные числа, возникающие из смысла задачи. Например, если вы решаете задачу про часы, то, скорее всего, у вас в программе появятся числа типа 60 (минут в часах) или 24 (часов в сутках). Тогда вы прямо указываете это число в программе, как, например, в задаче "Электронные часы - 1" с уровня 1А:</p>
        <pre>b = a % 60  # питон
        b := a mod 60;  // паскаль
        </pre>
        
        <p>Это абсолютно нормально. (Если вы будете потом писать серьезные большие программы, то от вас могут потребовать заводить специальные переменные-"константы" под эти числа, но сейчас речь не об этом, и в наших задачах это не обязательно.)</p>
        
        <p>Но бывает так, что в программе вам нужно какое-то число, которое вы с ходу не знаете, которое вам надо как-то вычислять. Например, вам надо в программе знать, на какой угол (сколько градусов) сдвигается минутная стрелка за одну минуту. Вряд ли вы это число назовете с ходу из головы. Зато понятно, как его считать: надо полный угол (360 градусов) поделить на 12 часов и то, что получится, поделить на 60 минут. </p>
        
        <p>Что вы в таком случае делаете? Вы берете калькулятор и на нем считаете, сколько будет <code>360/12/60</code>. Вы получаете 0.5 и прямо так и оставляете это число (0.5) прямо в коде программы:</p>
        <pre>b = a * 0.5  # питон
        b := a * 0.5;  // паскаль
        </pre>
        <p>Вот это уже неправильный подход.</p>
        
        <p>Любой язык программирования прекрасно работает как калькулятор. Поэтому не надо использовать внешний калькулятор. Просто напишите в программе прямо полностью выражение:</p>
        <pre>b = a * 360 / 12 / 60  # питон
        b := a * 360 / 12 / 60;  // паскаль
        </pre>
        
        <p>Вот так — намного лучше. Почему?</p>
        <ul>
        <li>Во-первых, так проще. Вам не надо лезть в калькулятор, считать там что-то, и вводить результат число в программу. Вы сразу тут вводите формулу, и компьютер делает работу за вас.</li>
        <li>Во-вторых, так надежнее. Вы можете случайно ввести в калькулятор не то число, или ошибиться при вводе результата в программу. Частая ситуация — если результат получается в виде длинной десятичной дроби, то вы вручную можете ввести слишком мало знаков. А компьютер посчитает за вас настолько точно, насколько он только может.</li>
        <li>Наконец, так понятнее. Если вы вернетесь к своей программе через неделю, вы вряд ли сразу вспомните, что такое 0.5 и откуда вы его взяли. А если вы увидите формулу <code>360/12/60</code>, все сразу станет понятнее, т.к. 360, 12 и 60 — вполне понятные в этой задаче числа, и скорее всего вы сразу вспомните, почему что и на что вы делили. Аналогично, программа будет понятнее для других людей, кто ее будет смотреть. Наконец, если у вас в формуле на самом деле ошибка (как простейший пример — вы разделили на 24 вместо 12), то заметить ее намного проще, чем если бы у вас в программе был только результат.</li>
        </ul>
        
        <p>Аналогичные соображения относятся и к другим ситуациям. Например, вам в программе может потребоваться код символа A. Вы можете посмотреть в таблицу символов и увидеть, что это 65. А можете написать <code>ord('A')</code>. Вот второй вариант намного лучше первого — пусть компьютер сам за вас считает, преимущества все те же, что описаны выше. Если вам надо знать, насколько коды заглавных букв отличаются от маленьких — тоже пишите формулу. И т.д.</p>
        
        <p>Вообще, общее правило:</p>
        <div style="border:1px solid black; padding: 10px;">Если вам в программе нужно использовать число, которое вы сразу называете из головы (например, количество минут в часе), то просто пишите это число. Если же вам нужно число, которые вы как-то вычисляете, то не пишите его в программе, а пишите формулу.</div></div>""",
                                              String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>About "strange numbers" in the code</h1>
        <p>Sometimes in your programs you may need to use some fixed numbers arising from the meaning of the task. For example, if you are solving a problem about the clock, then most likely you will have numbers like 60 (minutes in hours) or 24 (hours in days) in the program. Then you directly specify this number in the program, as, for example, in the task "Electronic Clock - 1" from level 1A:</p>
        <pre>b = a % 60 # python
        b := a mod 60; // pascal
        </pre>
        
        <p>This is absolutely normal. (If you are going to write serious large programs later, then you may be required to create special variables-"constants" for these numbers, but that's not what we're talking about now, and it's not necessary in our tasks.)</p>
        
        <p>But it happens that in the program you need some number that you don't know right off the bat, which you need to calculate somehow. For example, you need to know in the program by which angle (how many degrees) the minute hand shifts in one minute. It is unlikely that you will call this number right out of your head. But it is clear how to count it: it is necessary to divide the full angle (360 degrees) by 12 hours and divide what happens by 60 minutes. </p>
        
        <p>What are you doing in this case? You take a calculator and use it to calculate how much 360/12/60 will <code>be</code>. You get 0.5 and just leave this number (0.5) right in the program code:</p>
        <pre>b = a * 0.5 # python
        b := a * 0.5; // pascal
        </pre>
        <p>That's the wrong approach.</p>
        
        <p>Any programming language works great as a calculator. Therefore, it is not necessary to use an external calculator. Just write the entire expression in the program directly:</p>
        <pre>b = a * 360 / 12 / 60 # python
        b := a * 360 / 12 / 60 ; // pascal
        </pre>
        
        <p>That's so much better. Why?</p>
        <ul>
        <li>Firstly, it's easier this way. You don't have to go into the calculator, count something there, and enter the result number into the program. You immediately enter the formula here, and the computer does the work for you.</li>
        <li>Secondly, it is more reliable this way. You may accidentally enter the wrong number into the calculator, or make a mistake when entering the result into the program. A common situation is if the result is obtained in the form of a long decimal fraction, then you can manually enter too few characters. And the computer will count for you as accurately as it can.</li>
        <li>Finally, it's clearer this way. If you return to your program in a week, you are unlikely to immediately remember what 0.5 is and where you got it from. And if you see the formula <code>360/12/60</code>, everything will immediately become clearer, because 360, 12 and 60 are quite understandable numbers in this task, and most likely you will immediately remember why and by what you divided. Similarly, the program will be clearer for other people who will watch it. Finally, if you actually have an error in the formula (as the simplest example, you divided by 24 instead of 12), then it is much easier to notice it than if you had only the result in the program.</li>
        </ul>
        
        <p>Similar considerations apply to other situations. For example, you may need the A character code in the program. You can look at the symbol table and see that it is 65. Or you can write <code>ord('A')</code>. Here is the second option much better than the first — let the computer think for you, the advantages are the same as described above. If you need to know how the codes of capital letters differ from small ones — also write a formula. Etc.</p>
        
        <p>In general, the general rule is:</p>
        <div style="border:1px solid black; padding: 10px;">If you need to use a number in the program that you immediately call out of your head (for example, the number of minutes in an hour), then just write this number. If you need a number that you somehow calculate, then do not write it in the program, but write a formula.</div></div>"""), {skipTree: true})

export default arithmeticalOperations = () ->
    name = (lbl) ->
        if lbl == "" then "Арифметические операции"
        else if lbl == "!en" then "Arithmetic operations"
        else throw "unknown label #{lbl}"
    contestName = (lbl) ->
        if lbl == "" then "Задачи на арифметические операции"
        else if lbl == "!en" then "Problems on arithmetic operations"
        else throw "unknown label #{lbl}"
    return {
        topic: topic(name, contestName, [
            label(ruen(
                "<a href=\"https://notes.algoprog.ru/python_basics/0_quick_start.html\">Начало работы c питоном и Wing IDE</a>",
                "<a href=\"https://notes.algoprog.ru/python_basics/0_quick_start.html\">Getting Started with Python and Wing IDE</a>")),
            problem({testSystem: "ejudge", contest: "3003", problem: "1", id: "2938"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "2", id: "2939"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "3", id: "2941"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "4", id: "2942"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "5", id: "2943"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "6", id: "2944"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "7", id: "2947"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "8", id: "2951"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "9", id: "2952"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "10", id: "2936"}),
            problem({testSystem: "ejudge", contest: "3003", problem: "11", id: "2937"}),
        ], "arithmetical_operations"),
        advancedTopics: [
            topic("Вещественные числа", null, [
                label(ruen(
                    "Если вы еще не решали задачи на вещественные числа из уровня 1Б, то прочитайте там теорию и прорешайте все эти задачи. Там есть тонкости, которые обязательно надо знать.",
                    "If you haven't solved real numbers problems from level 1B yet, then read the theory there and solve all these problems. There are subtleties that you definitely need to know.")),
            ]),
            topic("Основы тестирования задач (без контеста)", null, [
                label(ruen(
                    "<a href=\"https://notes.algoprog.ru/testing/06_testing_main.html\">Теория по тестированию задач</a>. Вы там многое не поймете (особенно в примерах и в продвинутых методиках тестирования), но поймите хотя бы основы. В будущем, на более высоких уровнях, возвращайтесь к этому тексту.",
                    "<a href=\"https://notes.algoprog.ru/testing/06_testing_main.html\">Theory of testing tasks</a>. You won't understand much there (especially in examples and advanced testing techniques), but at least understand the basics. In the future, at higher levels, return to this text."))
            ]),
            topic("Задачи", "Продвинутые задачи на арифметические операции: в них запрещается пользоваться if'ами и циклами", [
                module25368(),
                label(ruen(
                    "<br>",
                    "<br>")),
                problem({testSystem: "ejudge", contest: "2003", problem: "1", id: "2946"}),
                problem(2945),
                problem(506),
                problem(534),
            ]),
            page("Разбор задачи \"Строки в книге\" (читать только тем, кто ее решил!)", ruen(
                                                                                            String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Разбор задачи "Строки в книге"</h1>
                
                <p>Первая идея, которая возникает в этой задаче -- это написать <code>N mod K</code> и <code>N div K+1</code>. Но, к сожалению, это не работает, когда <code>N</code> делится на <code>K</code>.</p>
                
                <p>Если бы в этой задаче можно было бы пользоваться условным оператором (if), то все было бы просто. Если бы эта задача была бы на реальной олимпиаде, то, конечно, так и пишите if. Но здесь в учебных целях if'ом пользоваться нельзя.</p>
                
                <p>На помощь придет следующая идея. Давайте сначала попробуем решить немного другую задачу: будем считать, что <i>всё</i>, что есть в этой задаче — строки в книге, страницы и строки на странице — <i>нумеруется с нуля</i>. (А <i>количество</i> строк на странице, конечно, как и раньше считается с 1.) Тогда, если, например, <code>K=3</code>, то на нулевой странице идут строки 0, 1, 2; на первой странице идут строки 3 4 5 и т.д. И несложно видеть, что вот как раз в этом случае достаточно просто разделить <code>N</code> на <code>K</code>; ответом будет <code>N div K</code> и <code>N mod K</code>; это работает во всех случаях.</p>
                
                <p>Теперь вернемся к нашей задаче. Нам вводится номер строки, если считать с единицы. Попробуем свести нашу задачу к той, которую мы только что решили; для этого вычтем из <code>N</code> единицу — получится номер строки в книге как если бы нумерация шла с нуля. Дальше разделим полученное число с остатком на <code>K</code> и получим правильные номер страницы и номер строки на странице, только нумерация всего всё еще идет с нуля. Прибавим к ответам 1, чтобы получить нумерацию с единицы.</p>
                
                <p>Итого решение задачи: <code>(N-1) div K + 1</code> и <code>(N-1) mod K + 1</code>.</p>
                
                <p>Вообще, это очень полезная идея — если задача плохо решается при нумерации с единицы, иногда оказывается намного проще перейти к нумерации с нуля. Особенно вот в подобных задачах, где вам явно надо делить на равные части.</p></div>""",
                                                                                            String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Analysis of the task "Lines in the book"</h1>
                
                <p>The first idea that arises in this problem is to write <code>N mod K</code> and <code>N div K+1</code>. But unfortunately, this doesn't work when <code>N</code> is divisible by <code>K.</code></p>
                
                <p>If the conditional operator (if) could be used in this task, then everything would be simple. If this task would have been at a real Olympiad, then, of course, write if. But here you can't use if for educational purposes.</p>
                
                <p>The following idea will come to the rescue. Let's first try to solve a slightly different problem: let's assume that <i>everything</i> in this problem — lines in the book, pages and lines on the page — is <i>numbered from scratch</i>. (And the <i>number</i> of lines on the page, of course, is counted from 1 as before.) Then, if, for example, <code>K=3</code>, then on the zero page there are lines 0, 1, 2; on the first page there are lines 3 4 5, etc. And it's easy to see that just in this case, it's enough to simply divide <code>N</code> by <code>K</code>; the answer will be <code>N div K</code> and <code>N mod K</code>; this works in all cases.</p>
                
                <p>Now let's get back to our task. We enter the line number, if we count from one. Let's try to reduce our problem to the one we just solved; to do this, we subtract one from <code>N</code> — we get the number of the line in the book as if the numbering started from zero. Next, divide the resulting number with the remainder by <code>K</code> and get the correct page number and line number on the page, only the numbering of everything is still going from zero. Add 1 to the answers to get the numbering from one.</p>
                
                <p>Total solution of the problem: <code>(N-1) div K + 1</code> and <code>(N-1) mod K + 1</code>.</p>
                
                <p>In general, this is a very useful idea — if the problem is poorly solved when numbering from one, sometimes it turns out to be much easier to switch to numbering from zero. Especially in such tasks, where you clearly need to divide into equal parts.</p></div>"""), {skipTree: true})
        ]
    }