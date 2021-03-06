import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

module24698 = () ->
    page("Про язык C++", String.raw"""
        <h1>Про язык C++</h1>
        <div class="box generalbox generalboxcontent boxaligncenter clearfix"><p>Если вы добрались до сюда, но еще пишете на паскале или на питоне, то, <b>возможно</b>, вам стоит потихоньку переходить на C++. Это не обозначает, что надо прямо сейчас все бросать и изучать новый язык программирования; это сильно зависит, во-первых, от вас, во-вторых, от текущего времени года. Я советую переходить на новый язык программирования весной-летом, когда основные олимпиады одного года уже закончились, а олимпиады следующего года еще не начались, но это также сильно зависит от вас самих (11-классникам, возможно, нет большого смысла переходить на C++ в школе — вас ему научат в университете, и т.п.) Поэтому <b>прежде чем переходить на C++, посоветуйтесь со мной</b>.</p>
        
        <p>На самом деле даже уровень 3Б — это немного рановато для перехода на C++, вполне можно и на паскале и на питоне заниматься и на более высоких уровнях, но в любом случае, если вы добрались до сюда, то поговорите про C++ со мной. Помимо уровня, у меня есть еще один критерий: переходить на C++ имеет смысл, если вы с довольно высокой вероятностью станете призерами областной олимпиады; но, опять-таки, этот критерий не строгий.</p>
        
        <p>К сожалению, сложно посоветовать какой-то конкретный ресурс или книгу для изучения C++. Язык довольно сложный, и есть определенный риск научиться ему неправильно, но вы уже знаете другой язык и понимаете все основные конструкции, поэтому вам будет намного проще изучать C++, чем если бы вы его учили с нуля.</p>
        
        <p><a href="https://notes.algoprog.ru/cpp/index.html">Общая теория по C++ в предположении, что вы уже знаете какой-то другой язык</a> (там довольно много,
        для начала можете прочитать «по диагонали», но вообще на уровне 3Б хорошо бы уже понимать 95% того, что там написано).</p>

        <p>Прочитав эту теорию, можете посдавать ряд задач с уровней 1А-1Б, чтобы понять основные конструкции языка (соответственно, и теорию можете читать по частям в соответствии с темами задач), а дальше продолжайте решать задачи на вашем текущем уровне, но на C++.</p>
        
        <p>Еще посмотрите "хорошие решения" на уровне 1 — там почти по каждой задаче есть "хорошее решение" на C++, а то и несколько; думаю, даже по ним можно выучить основы синтаксиса.</p>
        
        <p>При этом важный момент: <b>не забывайте тот язык программирования, на котором вы сейчас пишете</b>, особенно если это питон! Питон очень удобен в тех задачах, где не столь строгие ограничения по времени, да и вообще он будет очень полезен вам дальше в жизни, поэтому, если вы уже пишете на питоне, то не забывайте его, и используйте попеременно C++ и питон для задач, выбирая, какой язык лучше, для каждой задачи отдельно. Если вы пишете на паскале, то в принципе нет большой необходимости поддерживать этот навык, но все равно лучше его не забывать, особенно на случай, если вдруг у вас какая-то задача не будет решаться на C++.</p>
        
        </div>
    """, {skipTree: true})

export default cpp = () ->
    return {
        topic: topic("Про язык C++", null, [
            module24698(),
        ], "cpp"),
        count: false
    }
