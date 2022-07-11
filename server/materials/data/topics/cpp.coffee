import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module24698 = () ->
    page("Про язык C++", ruen(
                             String.raw"""<h1>Про язык C++</h1>
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><p>Если вы добрались до сюда, но еще пишете на паскале или на питоне, то, <b>возможно</b>, вам стоит потихоньку переходить на C++. Это не обозначает, что надо прямо сейчас все бросать и изучать новый язык программирования; это сильно зависит, во-первых, от вас, во-вторых, от текущего времени года. Я советую переходить на новый язык программирования весной-летом, когда основные олимпиады одного года уже закончились, а олимпиады следующего года еще не начались, но это также сильно зависит от вас самих (11-классникам, возможно, нет большого смысла переходить на C++ в школе — вас ему научат в университете, и т.п.) Поэтому <b>прежде чем переходить на C++, посоветуйтесь со мной</b>.</p>
        
        <p>На самом деле даже уровень 3Б — это немного рановато для перехода на C++, вполне можно и на паскале и на питоне заниматься и на более высоких уровнях, но в любом случае, если вы добрались до сюда, то поговорите про C++ со мной. Помимо уровня, у меня есть еще один критерий: переходить на C++ имеет смысл, если вы с довольно высокой вероятностью станете призерами областной олимпиады; но, опять-таки, этот критерий не строгий.</p>
        
        <p>К сожалению, сложно посоветовать какой-то конкретный ресурс или книгу для изучения C++. Язык довольно сложный, и есть определенный риск научиться ему неправильно, но вы уже знаете другой язык и понимаете все основные конструкции, поэтому вам будет намного проще изучать C++, чем если бы вы его учили с нуля.</p>
        
        <p><a href="https://notes.algoprog.ru/cpp/index.html">Общая теория по C++ в предположении, что вы уже знаете какой-то другой язык</a> (там довольно много,
        для начала можете прочитать «по диагонали», но вообще на уровне 3Б хорошо бы уже понимать 95% того, что там написано).</p>

        <p>Прочитав эту теорию, можете посдавать ряд задач с уровней 1А-1Б, чтобы понять основные конструкции языка (соответственно, и теорию можете читать по частям в соответствии с темами задач), а дальше продолжайте решать задачи на вашем текущем уровне, но на C++.</p>
        
        <p>Еще посмотрите "хорошие решения" на уровне 1 — там почти по каждой задаче есть "хорошее решение" на C++, а то и несколько; думаю, даже по ним можно выучить основы синтаксиса.</p>
        
        <p>При этом важный момент: <b>не забывайте тот язык программирования, на котором вы сейчас пишете</b>, особенно если это питон! Питон очень удобен в тех задачах, где не столь строгие ограничения по времени, да и вообще он будет очень полезен вам дальше в жизни, поэтому, если вы уже пишете на питоне, то не забывайте его, и используйте попеременно C++ и питон для задач, выбирая, какой язык лучше, для каждой задачи отдельно. Если вы пишете на паскале, то в принципе нет большой необходимости поддерживать этот навык, но все равно лучше его не забывать, особенно на случай, если вдруг у вас какая-то задача не будет решаться на C++.</p>
        
        </div>""",
                             String.raw"""<h1>About the C++ language</h1>
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><p>If you got here, but still write in pascal or python, then <b>maybe</b> you should slowly switch to C++. This does not mean that you have to drop everything right now and learn a new programming language; it strongly depends, firstly, on you, and secondly, on the current time of year. I advise you to switch to a new programming language in the spring-summer, when the main Olympiads of one year have already ended, and the Olympiads of the next year have not yet begun, but it also depends a lot on yourself (it may not make much sense for 11th graders to switch to C++ at school - you will be taught it at university, etc.) Therefore, <b>before switching to C++, consult with me</b>.</p>
        
        <p>In fact, even level 3B is a bit early to switch to C++, it is quite possible to study both pascal and python at higher levels, but in any case, if you got here, then talk about C++ with me. In addition to the level, I have another criterion: it makes sense to switch to C++ if you are quite likely to become winners of the regional Olympiad; but, again, this criterion is not strict.</p>
        
        <p>Unfortunately, it is difficult to recommend a specific resource or book for learning C++. The language is quite complex, and there is a certain risk of learning it incorrectly, but you already know another language and understand all the basic constructions, so it will be much easier for you to learn C++ than if you learned it from scratch.</p>
        
        <p><a href="https://notes.algoprog.ru/cpp/index.html">The general theory on C++ is assuming that you already know some other language</a> (there's quite a lot,
        to begin with, you can read "diagonally", but in general, at level 3B, it would be good to already understand 95% of what is written there).</p>

        <p>After reading this theory, you can solve a number of problems from levels 1A-1B in order to understand the basic constructions of the language (respectively, you can read the theory in parts according to the topics of the tasks), and then continue solving problems at your current level, but in C++.</p>
        
        <p>Also look at the "good solutions" at level 1 — there is a "good solution" in C++ for almost every problem, or even a few; I think you can even learn the basics of syntax from them.</p>
        
        <p>At the same time, an important point: do <b>not forget the programming language in which you are currently writing</b>, especially if it is python! Python is very convenient in those tasks where there are not so strict time limits, and in general it will be very useful to you later in life, so if you are already writing in python, then do not forget it, and use C++ and python alternately for tasks, choosing which language is better for each task separately. If you write in Pascal, then in principle there is no great need to support this skill, but it is still better not to forget it, especially in case you suddenly have some problem that will not be solved in C++.</p>
        
        </div>"""), {skipTree: true})

export default cpp = () ->
    return {
        topic: topic("Про язык C++", null, [
            module24698(),
        ], "cpp"),
        count: false
    }
