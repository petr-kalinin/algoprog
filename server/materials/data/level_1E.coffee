import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"
import page from "../lib/page"


contest_num_theory = () ->
    return contest("1E: Теория чисел", [
        problem({testSystem: "codeforces", contest: "371", problem: "B"}),
        problem({testSystem: "codeforces", contest: "361", problem: "B"}),
        problem({testSystem: "codeforces", contest: "817", problem: "A"}),
        problem({testSystem: "codeforces", contest: "248", problem: "B"}),
        problem({testSystem: "codeforces", contest: "299", problem: "A"}),
        problem({testSystem: "codeforces", contest: "59", problem: "B"}),
        problem({testSystem: "codeforces", contest: "762", problem: "A"}),
        problem({testSystem: "codeforces", contest: "762", problem: "A"}),
        problem({testSystem: "codeforces", contest: "158", problem: "D"}),
        problem({testSystem: "codeforces", contest: "743", problem: "C"}),
        problem({testSystem: "codeforces", contest: "158", problem: "D"}),    
        problem({testSystem: "codeforces", contest: "757", problem: "B"}),
        problem({testSystem: "codeforces", contest: "158", problem: "D"}),
        problem({testSystem: "codeforces", contest: "271", problem: "B"}),
        problem({testSystem: "codeforces", contest: "343", problem: "A"}),
        problem({testSystem: "codeforces", contest: "633", problem: "B"}),
        
        problem({testSystem: "codeforces", contest: "235", problem: "A"}), 
        problem({testSystem: "codeforces", contest: "735", problem: "D"}), 
        problem({testSystem: "codeforces", contest: "375", problem: "A"}), 
        problem({testSystem: "codeforces", contest: "353", problem: "C"}), 
        problem({testSystem: "codeforces", contest: "568", problem: "A"}), 
        problem({testSystem: "codeforces", contest: "385", problem: "C"}), 
        problem({testSystem: "codeforces", contest: "264", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "546", problem: "D"}), 
    ])
    
contest_greedy = () ->
    return contest("1E: Жадные алгоритмы", [
        problem({testSystem: "codeforces", contest: "118", problem: "C"}),
        problem({testSystem: "codeforces", contest: "777", problem: "D"}),
        problem({testSystem: "codeforces", contest: "1186", problem: "D"}),
        problem({testSystem: "codeforces", contest: "578", problem: "B"}),
        problem({testSystem: "codeforces", contest: "464", problem: "A"}),
        problem({testSystem: "codeforces", contest: "492", problem: "C"}),
        problem({testSystem: "codeforces", contest: "494", problem: "A"}),
        problem({testSystem: "codeforces", contest: "756", problem: "B"}),
        problem({testSystem: "codeforces", contest: "830", problem: "A"}),
        problem({testSystem: "codeforces", contest: "471", problem: "C"}),
        problem({testSystem: "codeforces", contest: "727", problem: "D"}),    
        problem({testSystem: "codeforces", contest: "384", problem: "B"}),
        problem({testSystem: "codeforces", contest: "436", problem: "A"}),
        problem({testSystem: "codeforces", contest: "205", problem: "B"}),
        problem({testSystem: "codeforces", contest: "48", problem: "D"}),
        problem({testSystem: "codeforces", contest: "1061", problem: "B"}),
        problem({testSystem: "codeforces", contest: "746", problem: "D"}), 
        problem({testSystem: "codeforces", contest: "3", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "727", problem: "D"}), 
        problem({testSystem: "codeforces", contest: "597", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "1526", problem: "C1"}), 
        problem({testSystem: "codeforces", contest: "976", problem: "E"}), 
        problem({testSystem: "codeforces", contest: "gym/101149", problem: "B", name: "Не время для драконов"}), 
        problem({testSystem: "codeforces", contest: "45", problem: "D"}), 
    ])
    
contest_ladderB3 = () ->
    return contest("1E: Ladder B Contest 3", [
        problem({testSystem: "codeforces", contest: "514", problem: "B"}),
        problem({testSystem: "codeforces", contest: "408", problem: "B"}),
        problem({testSystem: "codeforces", contest: "357", problem: "B"}),
        problem({testSystem: "codeforces", contest: "578", problem: "B"}),
        problem({testSystem: "codeforces", contest: "416", problem: "B"}),
        problem({testSystem: "codeforces", contest: "492", problem: "C"}),
        problem({testSystem: "codeforces", contest: "110", problem: "B"}),
        problem({testSystem: "codeforces", contest: "756", problem: "B"}),
        problem({testSystem: "codeforces", contest: "66", problem: "B"}),
        problem({testSystem: "codeforces", contest: "312", problem: "B"}),
        problem({testSystem: "codeforces", contest: "337", problem: "B"}),	
        problem({testSystem: "codeforces", contest: "384", problem: "B"}),
        problem({testSystem: "codeforces", contest: "361", problem: "B"}),
        problem({testSystem: "codeforces", contest: "205", problem: "B"}),
        problem({testSystem: "codeforces", contest: "182", problem: "B"}),
        problem({testSystem: "codeforces", contest: "234", problem: "B"}),
        problem({testSystem: "codeforces", contest: "746", problem: "D"}), 
        problem({testSystem: "codeforces", contest: "151", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "359", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "129", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "143", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "437", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "233", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "219", problem: "B"}),
		problem({testSystem: "codeforces", contest: "205", problem: "B"}),		
    ])

contest_ladderB4 = () ->
    return contest("1E: Ladder B Contest 4", [
        problem({testSystem: "codeforces", contest: "192", problem: "B"}),
        problem({testSystem: "codeforces", contest: "228", problem: "B"}),
        problem({testSystem: "codeforces", contest: "342", problem: "B"}),
        problem({testSystem: "codeforces", contest: "96", problem: "B"}),
        problem({testSystem: "codeforces", contest: "320", problem: "B"}),
        problem({testSystem: "codeforces", contest: "195", problem: "B"}),
        problem({testSystem: "codeforces", contest: "231", problem: "B"}),
        problem({testSystem: "codeforces", contest: "197", problem: "B"}),
        problem({testSystem: "codeforces", contest: "260", problem: "B"}),
        problem({testSystem: "codeforces", contest: "214", problem: "B"}),
        problem({testSystem: "codeforces", contest: "225", problem: "B"}),	
        problem({testSystem: "codeforces", contest: "63", problem: "B"}),
        problem({testSystem: "codeforces", contest: "281", problem: "B"}),
        problem({testSystem: "codeforces", contest: "189", problem: "B"}),
        problem({testSystem: "codeforces", contest: "94", problem: "B"}),
        problem({testSystem: "codeforces", contest: "244", problem: "B"}),
        problem({testSystem: "codeforces", contest: "216", problem: "D"}), 
        problem({testSystem: "codeforces", contest: "374", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "69", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "14", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "149", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "254", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "61", problem: "B"}), 
        problem({testSystem: "codeforces", contest: "103", problem: "B"}),
		problem({testSystem: "codeforces", contest: "9", problem: "B"}),		
    ])
	
contest_ladderB5 = () ->
    return contest("1E: Ladder B Contest 5", [
        problem({testSystem: "codeforces", contest: "27", problem: "B"}),
        problem({testSystem: "codeforces", contest: "99", problem: "B"}),
        problem({testSystem: "codeforces", contest: "275", problem: "B"}),
        problem({testSystem: "codeforces", contest: "190", problem: "B"}),
        problem({testSystem: "codeforces", contest: "56", problem: "B"}),
        problem({testSystem: "codeforces", contest: "114", problem: "B"}),
        problem({testSystem: "codeforces", contest: "41", problem: "B"}),
        problem({testSystem: "codeforces", contest: "22", problem: "B"}),
        problem({testSystem: "codeforces", contest: "31", problem: "B"}),
        problem({testSystem: "codeforces", contest: "75", problem: "B"}),
        problem({testSystem: "codeforces", contest: "340", problem: "B"}),	
        problem({testSystem: "codeforces", contest: "29", problem: "B"}),
        problem({testSystem: "codeforces", contest: "53", problem: "B"}),
        problem({testSystem: "codeforces", contest: "393", problem: "B"}),	
    ])
	
	
contest_geometry = () ->
    return contest("1E: Геометрия база", [
		problem(269),
        problem(270),
		problem(271),
		problem(274),
		problem(275),
		problem(433),
        problem(447),
        problem(434),
        problem(448),
        problem(435),
        problem(436),
        problem(437),
        problem(451),
        problem(438),
        problem(452),
        problem(439),
        problem(440),
        problem(441),
        problem(442),
        problem(443),
        problem(444),
        problem(446),
		problem(280),
        problem(281),
        problem(288),
    ])
	
	
greedy_theory = () -> 
    return page(
        "Про жадные алгоритмы", 
                                    String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>"Жадные" алгоритмы</h2>
        <p>Жадные алгоритмы — это алгоритмы, которые, на каждом шагу принимают локально оптимальное решение, не заботясь о том, что будет дальше. Они не всегда верны, но есть задачи, где жадные алгоритмы работают правильно.</p>
        
        <p>Пример жадного алгоритма следующий. Вспомните <a href="/material/p915" onclick="window.goto('/material/p915')();return false;">задачу "Платная лестница"</a> из контеста на ДП. Правильное решение в этой задаче — это именно динамика, но в этой задаче можно также придумать и следующее жадное решение (правда, неправильное). На каждом шагу у нас есть два варианта — подняться на следующую ступеньку или перепрыгнуть через ступеньку. Вот посмотрим, какой из этих двух вариантов дешевле, т.е. на какой из этих ступенек меньше цена, и сделаем такой шаг.</p>
        
        <p>Конечно, это решение неправильное, вот пример. Если на ступеньках написаны следующие числа:</p>
        <pre>1 2 10 2
        </pre>
        <p>то жадный алгоритм увидит, что изначально у него есть два варианта: сходить на ступеньку с числом 1 или с числом 2 — и пойдет на ступеньку с числом 1, т.к. это дешевле. Но правильное решение здесь — пойти на ступеньку с числом 2, т.к. потом мы сможешь перепрыгнуть ступеньку с числом 10.</p>
        
        <p>Этот пример четко показывает, почему жадные алгоритмы обычно не работают. Они не учитывают далекие последствия своих действий, они делают выбор, который оптимален только с учетом ближайших перспектив.</p>
        
        <p>(Сразу отмечу, что нередко жадные алгоритмы хочется применить в задачах на ДП. Да, многие задачи на жадность и на ДП похожи, просто в жадном алгоритме вы доказываете, что вариантов рассматривать не надо, а в ДП вы их честно рассматриваете. Поэтому если жадность не работает, то подумайте, не получится ли тут придумать ДП. Но на самом деле есть и много задач на жадность, где ДП не особенно придумаешь, и много задач на жадность, которые вообще не похожи на ДП.)</p>
        
        <p>Но бывают задачи, в которых жадность все-таки работает, в которых можно <i>доказать</i>, что жадный алгоритм корректен. На самом деле, в наиболее простых задачах корректность жадности очевидна (и на этом уровне у вас в основном будут именно задачи такого типа, более продвинутые будут на уровне 6Б), еще в некоторых задачах корректность жадности может быть не очевидна (или даже может быть несколько разных жадных алгоритмов, которые можно придумать, и непонятно, какой из них правильный), но вы можете написать жадность, отправить на проверку (если это возможно на конкретной олимпиаде) и сразу узнать, корректна она или нет. Наконец, даже если жадность некорректна, она нередко работает в простых случаях, поэтому жадные алгоритмы нередко неплохо подходят на роль частичных решений.</p>
        
        <h3>Как доказывать жадность?</h3>
        
        <p>Как обычно доказывают жадные алгоритмы? На самом деле, на текущем уровне вам не обязательно научиться их доказывать, но если поймете, что написано ниже, то будет хорошо.</p>
        
        <p>Есть два подхода к доказательству задач на жадность. Первый вариант более общий. Он может быть применен в тех задачах, где вам надо сделать несколько последовательных шагов, несколько последовательных выборов. (В примере задачи про платную лестницу выше — вы именно делаете несколько последовательных выборов "на какую ступеньку сходить".) Вам надо доказать, что если вы сделаете локально оптимальный выбор, то он не отменит возможность придти к глобально оптимальному решению. Обычно доказательство идет так: возьмем решение, построенное жадным алгоритмом, возьмем оптимальное решение, найдем первый шаг, где они отличаются, и докажем, что оптимальное решение можно поменять так, чтобы оно осталось оптимальным, но этот отличающийся шаг стал совпадать с жадным решением. Тогда мы имеем оптимальное решение, которое совпадает с жадным на один шаг дальше. Тогда очевидно, что есть оптимальное решение, которое полностью совпадает с жадным, т.е. что жадное является оптимальным.</p>
        
        
        <p>Пример. Пусть у нас задача: есть $N$ вещей, каждая со своим весом. Надо выбрать как можно больше вещей так, чтобы суммарный вес не превосходил заданного числа $C$. Очевидное жадное решение: брать вещи, начиная с самой легкой, пока суммарный вес не превосходит $C$. Как только превзошел — все, выводим ответ.</p>
        
        <p>Давайте докажем. Рассмотрим жадное решение, оно берет себе вещи в порядке возрастания веса. Рассмотрим оптимальное решение и рассмотрим первый шаг, когда в жадном решении мы отклонились от оптимального. Это значит, что в жадном решении мы взяли вещь (пусть это вещь $X$), которая не входит в оптимальное решение. Значит, в оптимальном решении должна быть какая-то вещь (пусть это вещь $Y$), которой нет в жадном, иначе в жадном решении было бы больше вещей, чем в оптимальном, что противоречит оптимальности. При этом вещь $Y$ не легче, чем вещь $X$, т.к. в жадном решении мы брали все вещи в порядке возрастания веса. Тогда возьмем оптимальное решение, и заменим в нем вещь $Y$ на вещь $X$. Суммарный вес вещей в оптимальном решении не увеличится, количество вещей не уменьшится, поэтому решение по-прежнему будет оптимальным. Но оно будет совпадать с жадным на шаг дальше. ЧТД.</p>
        
        <p>Второй вариант доказательства подходит к тем задачам, где вам надо выбрать некоторый <i>порядок</i> предметов: набор предметов вам задан, а надо выбрать, в каком порядке их расположить, чтобы что-то оптимизировать. Тогда вы можете попробовать доказать, что предметы надо расположить в порядке возрастания некоторого параметра (это и будет жадным алгоритмом). Доказательство будет таким: пусть в оптимальном решении предметы идут не в таком порядке. Тогда найдем два соседних предмета, которые идут в неправильном порядке, и поменяем их местами, и докажем, что решение не ухудшится, а значит, останется оптимальным. Тогда очевидно, что жадное решение (которое расставляет предметы в порядке возрастания этого параметра) будет корректным.</p>
        
        <p>Пример. В олимпиадах типа ACM участники решают задачи. За каждую решенную задачу они получают штраф, равный времени, прошедшему с начала тура до момента решения этой задачи. Предположим, что у нас есть идеальная команда, и она тратит $t_i$ минут на решение $i$-й задачи (и никогда не делает неудачных попыток). В каком порядке им надо решать задачи, чтобы получить минимальный штраф?</p>
        
        <p>Жадный алгоритм: в порядке возрастания $t_i$. Доказательство. Пусть у нас есть оптимальное решение, в котором $t_i$ не отсортированы по возрастанию. Найдем две задачи, $i$ и $j$, такие, что в оптимальном решении мы решаем сначала решаем задачу $i$, а сразу после нее задачу $j$, при этом $t_i&gt;=t_j$. Поменяем их местами. Что изменится в плане штрафного времени? Для всех задач, которые мы решали до этих двух, штрафное время не изменится. Для всех задач, которые мы решали после этих двух, штрафное время тоже не изменится. (Именно для этого мы и брали соседние задачи.) Штрафное же время по этим задачам было $t_i+(t_i+t_j)$, а стало $t_j+(t_i+t_j)$. Поскольку $t_i&gt;=t_j$, то решение не ухудшилось, значит, оно осталось оптимальным. ЧТД.</p>
        
        <p>(Оба доказательства выше в принципе можно переформулировать на доказательства от противного: что если оптимальное решение сильно отличается от жадного, то мы меняем оптимальное решение, получаем решение, которое строго лучше, значит, оптимальное решение было не оптимальным. Да, так доказывать тоже можно, но надо аккуратно обойтись со случаем равных значений — случаем $t_i=t_j$ или случаем двух вещей одного веса в первой задаче.)</p>
        
        <p>На самом деле, второй вариант доказательства на самом деле позволяет <i>придумывать</i> жадность в тех задачах, где она не очевидна (если не поймете этот абзац, то не страшно). Если вам в задаче надо расположить объекты в некотором порядке, и вы не знаете, в каком, подумайте: пусть у вас есть некоторый порядок. Поменяем местами два соседних предмета, посмотрим, как изменится решение. Пусть оценка старого решения была $X$, а нового — $Y$ (это, конечно, функция решения). Напишем условие $X&gt;Y$, т.е. что решение улучшилось. Попробуем его преобразовать так, чтобы свести все к характеристикам двух объектов, которые мы меняем местами. Тогда, может быть, мы обнаружим, что условие $X&gt;Y$ эквивалентно условию $f(i)&gt;f(j)$, где $i$ и $j$ — предметы, которые мы поменяли местами, а $f$ — какая-то функция. Тогда очевидно, что в правильном решении надо просто отсортировать предметы по значению функции $f$.</p>
        
        <p>Жадные алгоритмы (Algoprog, Петр Калинин: <a href='https://algoprog.ru/material/greedy_simple.1'>https://algoprog.ru/material/greedy_simple.1</a>)</p></div>""", 
        {skipTree: true})
        
export default level_1E = () ->
    return level("1E", [
        label("Арифметические алгоритмы (ЛКШ С' август 2013, Владимир Гуровиц). Смотреть все 6 видео в данной теме: <a href='https://sis.khashaev.ru/2013/august/c-prime/lK2k26ATt38/'>https://sis.khashaev.ru/2013/august/c-prime/lK2k26ATt38/</a>"),
        label("Бинарное возведение в степень (e-maxx): <a href='http://e-maxx.ru/algo/binary_pow'>http://e-maxx.ru/algo/binary_pow</a>"),
        label("Алгоритм Евклида нахождение НОД (e-maxx): <a href='http://e-maxx.ru/algo/euclid_algorithm'>http://e-maxx.ru/algo/euclid_algorithm</a>"),
        label("Решето Эратосфена (e-maxx): <a href='http://e-maxx.ru/algo/eratosthenes_sieve'>http://e-maxx.ru/algo/eratosthenes_sieve</a>"),
        contest_num_theory(),
        
        contest_ladderB3(),
        greedy_theory(),
        label("Жадные алгоритмы (Алгоритмика от Tinkoff Generation: <a href='https://ru.algorithmica.org/cs/combinatorial-optimization/greedy/'>https://ru.algorithmica.org/cs/combinatorial-optimization/greedy/</a>"),
        label("При решении задач обязательно нужно применить 'жадный' подход"),
        contest_greedy(),
        
        contest_ladderB4(),

        label("Геометрия (ЛКШ B' июль 2013, Петр Калинин). Смотреть все видео в данной теме: https://sis.khashaev.ru/2013/july/b-prime/SHKJoyngn9E/"),
        label("Геометрия (Алгоритмика от Tinkoff Generation: <a href='https://ru.algorithmica.org/cs/geometry-basic/'>https://ru.algorithmica.org/cs/geometry-basic/</a>"),
        contest_geometry(),

        contest_ladderB5(),
    ])
