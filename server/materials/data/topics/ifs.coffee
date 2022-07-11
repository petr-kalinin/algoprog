import contest from "../../lib/contest"
import label from "../../lib/label"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module15986 = () ->
    page(ruen(
        "Разбор задачи про Франциска Ксавьера (читать только тем, кто решил саму задачу!)",
        "Analysis of the problem about Francis Xavier (read only to those who solved the problem itself!)"), ruen(
                                                                                                 String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>Разбор задачи про Франциска Ксавьера</h2>
        <p>Если вы еще не решили задачу про день святого Франциска Ксавьера из контеста "Продвинутые задачи на условный оператор", то не читайте дальше, сначала решите задачу.</p><br>
        -<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>
        <p>Как можно решать эту задачу? Конечно, можно решить тупо: прогнать цикл от года рождения до года смерти и каждый год проверить. По условию годы не превосходят 2000, поэтому такое решение вполне успеет по времени.</p>
        <p>Но это — задачи на условный оператор, поэтому решение с циклами разрешать я тут не буду. Тем более что в принципе понятно сразу, что задачу можно решить, просто сделав  немного вычислений, без циклов — так что программа будет работать очень быстро независимо от входных данных. (А решение с циклом может очень медленно работать, если годы во входных данных могут быть очень большими — например, на тесте 0 1000000000.) (Тем не менее, это все относится к нашему учебному курсу. Если бы такая задача вам попалась бы на олимпиаде, то, конечно, надо было бы просто написать цикл.)</p>
        <p>Как написать такое решение? В принципе, можно работать с данными «как есть», просто написать несколько if'ов, и в каждом сразу вычислять и считать ответ. Пример такого решения:
        </p><pre>{$mode delphi}
        var r,s:integer;
        begin
        read(r,s);
        if (s&lt;1605) then writeln(0)
        else if ((r=1605) or (r mod 10=5)) then writeln((s-r) div 10)
        else if (r&gt;1605) then
        	if (r mod 10&lt;5) then writeln((s-(r-r mod 10 +5))div 10 +1)
        	else writeln((s-(r-r mod 10 +15))div 10 +1)
        else writeln((s-1605) div 10 +1);
        end.
        </pre>
        Но такое решение писать довольно сложно (и вообще, я на 100% не уверен, что решение выше верное — оно, конечно, проходит все тесты, но я не уверен, что тесты там достаточно полные).<p></p>
        <p>Проще поступить следующим образом — и на самом деле это подход, встречающийся во многих задачах. Надо понимать, что у вас нет цели написать одну большую формулу (ну или несколько формул с разбором случаев). Компьютер способен на более сложные действия, и этим надо воспользоваться.</p>
        <p>Итак, пусть мы считали данные:
        </p><pre>s, f = map(int, input().split())</pre>
        (s и f от start и finish).
        <p></p>
        
        <p>Давайте, во-первых, сдвинем начало отсчета времени на 1605 год, т.е. вычтем из всех годов 1605:
        </p><pre>s = s - 1605
        f = f - 1605
        </pre>
        Это уже существенно упростит задачу: теперь нас интересуют года, делящиеся на 10, с этим работать намного проще, чем с годами, которые дают остаток 5 при делении на 10. Кроме того, дальше нам сравнения надо будет делать не с 1605, а с нулем, что позволяет не ошибиться с годом.<p></p>
        
        <p>Уже теперь формулы и if'ы будут проще. Но мы пойдем далее и вместо годов рождения и смерти посчитаем и будем использовать <i>первый год</i>, когда он мог коснуться мощей, и последний такой год.</p>
        <p>Как определить первый год, когда он мог коснуться мощей? Казалось бы, это первый год, кратный десяти, после года рождения. Соответствующую формулу несложно придумать:</p>
        <pre>s = s - s % 10 + 10
        </pre>
        <p>Правда, как только вы написали это выражение (или даже как только подумали про это), надо тут же подумать: а всегда ли это работает? Тут же должны возникнуть четыре соображения:</p>
        <ul>
        <li>А если s кратно 10 сразу?</li>
        <li>А если полученный год больше года смерти?</li>
        <li>А если полученный год меньше нуля?</li>
        <li>А верно ли это работает для отрицательных <code>s</code>?</li>
        </ul>
        <p>На первый вопрос ответ простой: наша формула сработает верно. Действительно, по условию в год рождения крестьянин не мог касаться мощей, поэтому если год рождения был кратен 10, то первый год, когда он мог коснуться мощей, будет на 10 лет позже — это наша формула и дает.</p>
        <p>Второй вопрос пока запомним, его рассмотрим позже; кроме того, запомним сразу, что надо будет проверить такой тест — например, тест 3 5, точнее, с учетом того, что мы вычитали 1605 из всех годов, то тест 1608 1610.</p>
        <p>Четвертый вопрос на самом деле не вопрос: в питоне взятие остатка для отрицательных чисел работает разумно (например, <code>(-3) % 10 == 7</code>, подумайте, почему это разумно). В результате если изначально было <code>s = -3</code>, то у нас получится <code>s = 0</code>, что и следовало ожидать. Вот в других языках программирования с этим надо аккуратно обойтись.</p>
        <p>И наконец третий вопрос обрабатывается легко: если полученный год меньше нуля, то на самом деле первый раз крестьянин мог коснуться мощей в нулевом году:</p>
        <pre>if s &lt; 0:
            s = 0
        </pre>
        <p>Аналогично поступим с годом смерти: нам надо определить последний год, кратный 10, который был не позже года смерти. Формула еще проще:</p>
        <pre>f = f - f % 10
        </pre>
        <p>Здесь тоже возникают те же четыре вопроса, точнее уже два вопроса, потому что с поведением остатка от деления для отрицательных чисел мы уже разобрались, а вопросы "полученный год меньше года рождения" и "полученный год меньше нуля" — это теперь одна и та же ситуация. Ее мы рассмотрим позже, а на оставшийся вопрос "если f кратно 10 сразу" ответ такой же: наш код работает правильно, т.к. в год смерти он мог коснуться мощей.</p>
        <p>Теперь мы знаем первый и последний год, когда крестьянин мог коснуться мощей. Ответ на задачу уже вычисляется совсем легко: <code>(f-s) // 10 + 1</code>, только надо не забыть те вопросы, которые мы откладывали. Несложно видеть, что они все объединяются в один <code>if f &lt; s</code>, и в итоге получаем простой вывод ответа:</p>
        <pre>if f &lt; s: 
            print(0)
        else:
            print((f-s) // 10 + 1)
        </pre>
        Вот и все. Итоговая программа:
        <pre>s, f = map(int, input().split())
        s = s - 1605
        f = f - 1605
        
        s = s - s % 10 + 10
        if s &lt; 0:
            s = 0
        
        f = f - f % 10
        
        if f &lt; s: 
            print(0)
        else:
            print((f-s) // 10 + 1)
        </pre>
        <p>Программа намного проще, чем та, что приведена в начале. Ошибки в ней искать тоже намного проще, т.к. можно проверять ее по частям; мы прекрасно понимаем, в чем физический смысл каждого куска.</p>
        <p>(В частности, если бы это был бы не питон, то у вас возникли бы обсуждаемые выше проблемы с остатками для отрицательных чисел. Например, что в c++, что в паскале получается <code>(-3) % 10 == -3</code> (c++) и <code>(-3) mod 10 == -3</code> (паскаль), поэтому коррекции <code>s</code> и <code>f</code> будут неверными. Надо такие случаи учитывать особо, но в любом случае как только вы находите такой баг, вы сразу понимаете, где он и как его исправить. В решении с кучей вложенных if'ов искать такую ошибку было бы намного сложнее.</p>
        <p>Итак, и это полезно не только в этой задаче, но и во многих других. Если вы понимаете, что задача решается формулой, не надо сразу бросаться эту формулу писать. Компьютер может сделать дополнительные действия, вы можете провести какие-то вычисления, например, упростив входные данные, или вычислив какие-нибудь дополнительные переменные, и т.д. Не бойтесь этого делать.</p>
        <p>И вторая мораль: если вы видите, что вы можете упростить входные данные к задаче, это зачастую полезно сделать. Последовательно упрощая данные, вы делаете решение проще и проще.</p></div>""",
                                                                                                 String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>Analysis of the problem about Francis Xavier</h2>
        <p>If you haven't solved the problem about St. Francis Xavier's Day from the contest "Advanced Conditional Operator problems", then don't read on, solve the problem first.</p><br>
        -<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>-<br>
        <p>How can this task be solved? Of course, you can solve stupidly: run the cycle from the year of birth to the year of death and check every year. According to the condition, the years do not exceed 2000, so such a decision will be quite in time.</p>
        <p>But these are tasks for a conditional operator, so I will not solve the solution with cycles here. Moreover, in principle, it is immediately clear that the problem can be solved simply by doing a few calculations, without cycles — so the program will work very quickly regardless of the input data. (And a solution with a loop can work very slowly if the years in the input data can be very large — for example, on the test 0 1000000000.) (Nevertheless, this all applies to our training course. If you had such a task at the Olympics, then, of course, you would just have to write a cycle.)</p>
        <p>How to write such a solution? In principle, you can work with the data "as is", just write several if's, and in each immediately calculate and count the answer. An example of such a solution:
        </p><pre>{$mode delphi}
        var r,s:integer;
        begin
        read(r,s);
        if (s&lt;1605) then writeln(0)
        else if ((r=1605) or (r mod 10=5)) then writeln((s-r) div 10)
        else if (r&gt;1605) then
        	if (r mod 10&lt;5) then writeln((s-(r-r mod 10 +5))div 10 +1)
        	else writeln((s-(r-r mod 10 +15))div 10 +1)
        else writeln((s-1605) div 10 +1);
        end.
        </pre>
        But it's quite difficult to write such a solution (and in general, I'm not 100% sure that the solution above is correct — it, of course, passes all the tests, but I'm not sure that the tests there are complete enough).<p></p>
        <p>It is easier to do the following — and in fact this is an approach found in many tasks. It should be understood that you do not have a goal to write one big formula (well, or several formulas with case analysis). The computer is capable of more complex actions, and this should be taken advantage of.</p>
        <p>So, let's say we counted the data:
        </p><pre>s, f = map(int, input().split())</pre>
        (s and f from start and finish).
        <p></p>
        
        <p>First of all, let's shift the start of the countdown to 1605, i.e. subtract 1605 from all the years:
        </p><pre>s = s - 1605
        f = f - 1605
        </pre>
        This will greatly simplify the task: now we are interested in years divisible by 10, it is much easier to work with this than with years that give a remainder of 5 when divided by 10. In addition, then we will have to make comparisons not with 1605, but with zero, which allows us not to make a mistake with the year.<p></p>
        
        <p>Already now formulas and if's will be easier. But we will go further and instead of the years of birth and death, we will count and use the <i>first year</i> when he could touch the relics, and the last such year.</p>
        <p>How to determine the first year when he could touch the relics? It would seem that this is the first year, a multiple of ten, after the year of birth. The corresponding formula is easy to come up with:</p>
        <pre>s = s - s % 10 + 10
        </pre>
        <p>However, as soon as you wrote this expression (or even as soon as you thought about it), you should immediately think: does it always work? Four considerations should immediately arise:</p>
        <ul>
        <li>And if s is a multiple of 10 at once?</li>
        <li>And if the year received is more than the year of death?</li>
        <li>And if the resulting year is less than zero?</li>
        <li>Does this work correctly for negative <code>s</code>?</li>
        </ul>
        <p>The answer to the first question is simple: our formula will work correctly. Indeed, according to the condition in the year of birth, the peasant could not touch the relics, so if the year of birth was a multiple of 10, then the first year when he could touch the relics would be 10 years later — this is our formula and gives.</p>
        <p>We will remember the second question for now, we will consider it later; in addition, we will immediately remember that it will be necessary to check such a test — for example, test 3 5, more precisely, taking into account the fact that we subtracted 1605 from all years, then the test 1608 1610.</p>
        <p>The fourth question is not really a question: in python, taking the remainder for negative numbers works reasonably (for example, <code>(-3) % 10 == 7</code>, think about why this is reasonable). As a result, if initially it was <code>s = -3</code>, then we will get <code>s = 0</code>, which is to be expected. Here in other programming languages, this should be handled carefully.</p>
        <p>And finally, the third question is handled easily: if the resulting year is less than zero, then in fact the first time a peasant could touch the relics in the zero year:</p>
        <pre>if s &lt; 0:
            s = 0
        </pre>
        <p>Let's do the same with the year of death: we need to determine the last year, a multiple of 10, which was no later than the year of death. The formula is even simpler:</p>
        <pre>f = f - f % 10
        </pre>
        <p>Here, too, the same four questions arise, or rather, two questions already, because we have already figured out the behavior of the remainder of the division for negative numbers, and the questions "the resulting year is less than the year of birth" and "the resulting year is less than zero" are now the same situation. We will consider it later, and the answer to the remaining question "if f is a multiple of 10 at once" is the same: our code works correctly, because in the year of death it could touch the relics.</p>
        <p>Now we know the first and last year when a peasant could touch the relics. The answer to the problem is already calculated quite easily: <code>(f-s) // 10 + 1</code> just don't forget the questions we've been putting off. It is not difficult to see that they are all combined into one <code>if f &lt; s</code>, and as a result we get a simple output of the answer:</p>
        <pre>if f &lt; s: 
            print(0)
        else:
            print((f-s) // 10 + 1)
        </pre>
        That's all. Final program:
        <pre>s, f = map(int, input().split())
        s = s - 1605
        f = f - 1605
        
        s = s - s % 10 + 10
        if s &lt; 0:
            s = 0
        
        f = f - f % 10
        
        if f &lt; s: 
            print(0)
        else:
            print((f-s) // 10 + 1)
        </pre>
        <p>The program is much simpler than the one given at the beginning. It is also much easier to look for errors in it, because you can check it in parts; we perfectly understand what the physical meaning of each piece is.</p>
        <p>(In particular, if it were not python, then you would have the problems discussed above with residuals for negative numbers. For example, in c++, in pascal it turns out <code>(-3) %10 == -3</code> (c++) and <code>(-3) mod 10 == -3</code> (pascal), so the corrections <code>s</code> and <code>f</code> will be incorrect. It is necessary to take such cases into account especially, but in any case, as soon as you find such a bug, you immediately understand where it is and how to fix it. In a solution with a bunch of nested if's, it would be much more difficult to look for such an error.</p>
        <p>So, and it is useful not only in this task, but also in many others. If you understand that the problem is solved by a formula, do not immediately rush to write this formula. The computer can do additional actions, you can perform some calculations, for example, simplifying the input data, or calculating some additional variables, etc. Don't be afraid to do it.</p>
        <p>And the second moral: if you see that you can simplify the input data to the task, it is often useful to do so. By consistently simplifying the data, you make the solution simpler and simpler.</p></div>"""), {skipTree: true})

export default ifs = () ->
    return {
        topic: topic(
            ruen("Условный оператор", "Conditional operator"),
            ruen("Задачи на условный оператор", "Problems on conditional operator"),
        [label(ruen(
             "<a href=\"https://notes.algoprog.ru/python_basics/1_if.html\">Питон: теория по условному оператору</a>",
             "<a href=\"https://notes.algoprog.ru/python_basics/1_if.html\">Python: Conditional operator theory</a>")),
            label(ruen(
                "<a href=\"https://blog.algoprog.ru/do-not-check-limits/\">Не надо проверять, выполняются ли ограничения из условия</a>",
                "<a href=\"https://blog.algoprog.ru/do-not-check-limits/\">It is not necessary to check whether the restrictions from the condition are met</a>")),
            problem({testSystem: "ejudge", contest: "3004", problem: "1", id: "292"}),
            problem({testSystem: "ejudge", contest: "3004", problem: "2", id: "293"}),
            problem({testSystem: "ejudge", contest: "3004", problem: "3", id: "2959"}),
            problem({testSystem: "ejudge", contest: "3004", problem: "4", id: "294"}),
            problem({testSystem: "ejudge", contest: "3004", problem: "5", id: "253"}),
        ], "ifs"),
        advancedTopics: [
            contest(ruen(
                "Продвинутые задачи на условный оператор: в них запрещено пользоваться циклами и массивами",
                "Advanced conditional operator tasks: it is forbidden to use loops and arrays in them"), [
                problem(297),
                problem(255),
                problem(258),
                problem(38),
                problem(264),
                problem(235),
                problem(303),
                problem(481),
                problem(234),
            ]),
            module15986()            
        ]
    }
