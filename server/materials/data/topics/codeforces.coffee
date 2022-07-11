import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"
import {ruen} from "../../lib/util"

module17501 = () ->
    page(ruen(
        "Про сайт Codeforces",
        "About the Codeforces website"), ruen(
                                    String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Про сайт Codeforces</h1>
        <p>Если вы добрались до сюда, то вы уже довольно хорошо программируете, и имеет смысл не только решать задачи нашего курса, но также и дополнительно более-менее регулярно тренироваться. Рекомендую вам зарегистрироваться на сайте <a href="https://codeforces.com">codeforces.com</a> (есди он у вас вдруг открывается на английском языке, то в правом верхнем углу можно переключиться на русский), изучить его и время от времени принимать участие в его "раундах".</p>
        
        <p>А именно, на этом сайте регулярно проводятся соревнования — "раунды". Они бывают в среднем раз в одну-две недели (каждый раунд писать не обязательно, но я бы вам рекомендовал хотя бы раз в месяц-полтора писать раунды). Это не какие-то призовые олимпиады и т.п., в них имеет смысл участвовать из интереса, и с целью тренировки. Раунды проводятся по разным правилам, ниже я опишу наиболее распространенный вариант.</p>
        
        <p>Во-первых, у всех участников codeforces есть так называемый "рейтинг" — целое число, показывающее, насколько вы успешно выступали на раундах codeforces. Если вы хорошо выступаете, ваш рейтинг будет расти, если плохо, то падать. От рейтинга зависит цвет, которым ваш ник пишется на страничках codeforces. Кроме того, все участники codeforces делятся на два "дивизиона" по рейтингу. Вы изначально участвуете во втором дивизионе, если ваш рейтинг становится достаточно высоким (1700 и выше), то вы переходите в первый дивизион.</p>
        
        <p>Раунды обычно проводятся отдельно по дивизионам. Наиболее часто проводятся два параллельных раунда — для первого и для второго дивизиона; задачи частично пересекаются, частично отличаются. Бывают объединенные раунды для двух дивизионов, бывают раунды только для второго дивизиона. Бывают раунды по совсем особым схемам и правилам. Большинство раундов являются "рейтинговыми", т.е. результаты участия в них влияют на ваш рейтинг, но бывают и "нерейтинговые" раунды. Обычно о рейтинговости раунда предупреждают заранее.</p>
        
        <p>Наиболее часто раунды проводятся по следующим правилам. Для участия в раунде надо заранее зарегистрироваться на этот раунд (т.е. не просто зарегистрироваться на сайте, но еще и нажать специальную кнопку "зарегистрироваться на раунд"), обычно регистрация на раунд заканчивается минут за 5-10 до начала раунда. Раунд длится 2-2.5 часа. Вам предлагается 5 задач, упорядоченных по сложности (по крайней мере как думают авторы задач). У каждой задачи есть своя стоимость, определяющая количество баллов, которые вы получите при успешном решении этой задачи. У простых задач стоимость невысокая (обычно от 500), у сложных — высокая (обычно 2500). (Эти баллы не имеют прямого отношения к баллам рейтинга.)</p>
        
        <p>Вы можете решать задачи в произвольном порядке (хотя обычно все решают от простых к сложным), на любых допустимых языках программирования. Когда вы считаете, что вы написали решение, вы можете его отправить на проверку (аналогично тому, как вы делаете на нашем сайте). Ваша задача будет проверена на так называемых "претестах" — некотором наборе тестов, который не обязательно является полным (т.е. вы можете пройти все претесты, даже если ваше решение не совсем правильное). Если ваше решение не прошло хотя бы один претест, оно не принимается, и вам об этом сообщают. Если оно прошло все претесты, то оно "принимается на окончательную проверку", которая будет проходить в конце раунда.</p>
        
        <p>Если ваше решение не прошло претесты, вы можете его пересдавать. Если оно прошло все претесты, вы все равно можете его пересдать — если, например, вы нашли у себя ошибку. При этом за каждую лишнюю посылку вы впоследствии получите 50 штрафных баллов.</p>
        
        <p>Стоимость задач падает со временем, к концу контеста опускаясь до примерно половины начальной стоимости. Соответственно, если в итоге окажется, что вы решили задачу, то вы получите столько баллов, сколько она стоила в момент вашей последней посылки, минус 50 баллов за каждую предыдущую посылку. В течение раунда вы можете смотреть его текущие результаты, т.е. кто что на данный момент решил.</p>
        
        <p>Вдобавок ко всему этому, существует система "взломов". А именно, если ваше решение по некоторой задаче прошло претесты, вы можете его "заблокировать" (нажав на соответствующую кнопку в интерфейсе). После этого вы уже не можете перепосылать эту задачу, но зато вы получаете возможность смотреть исходные коды других участников по этой задаче (только те, что прошли претесты). Чтобы вам не возиться в огромной таблице результатов, все участники перед раундом псевдослучайным образом делятся по "комнатам", и вы можете просматривать решения только участников из своей комнаты. Чтобы просмотреть уод участника, надо сделать двойной щелчок по соответствующей ячейке в таблице результатов комнаты.</p>
        
        <p>Цель просмотра решения — попробовать найти в нем ошибки. Если вы думаете, что вы нашли ошибку в решении, вы можете придумать тест, на котором, как вы думаете, это решение будет работать неправильно, и отправить этот тест в систему — попробовать "взломать" это решение. Система тут же проверит это решение на вашем тесте и, если оно действительно не работает, то вы получите плюс 100 баллов, если вы ошиблись, то вы получаете минус 50 баллов. В случае успешного взлома участник, которого взломали, это увидит, и (если он еще не заблокировал задачу) сможет перепослать свое решение. Если он уже заблокировал задачу, то ему не повезло. Соответственно, аналогично другие участники могут взламывать ваши решения; при этом, конечно, вы не видите тест, которым вас взломали.</p>
        
        <p>При просмотре решения вы не можете куда-либо копировать его текст; вы должны смотреть код чисто глазами.</p>
        
        <p>После окончания времени раунда все решения перетестируются на полноценном наборе тестов. Теперь если у вас все-таки было неверное решение, то оно почти наверняка не пройдет какой-нибудь из полноценных тестов. После этого вычисляются окончательные результаты. А именно, по каждой задаче, которую вы сдали, вам начисляются баллы, соответствующие стоимости задачи в тот момент, когда вы послали по ней последнее решение, минус 50 баллов за каждую предыдущую посылку по этой задаче. По тем задачам, которые вы так и не сдали, штрафные баллы не начисляются. Добавляются результаты взломов (100 баллов за успешный взлом, 50 баллов за неуспешный), и получается ваш итоговый балл, определяющий место, которое вы в итоге занимаете. От этого места зависит прирост вашего рейтинга.</p>
        
        <p>После каждого раунда публикуются краткие разборы задач (в тот же день или через день-два). Рекомендую вам их читать. Кроме того, после окончания раунда вы все еще можете "дорешивать" — отправлять задачи на проверку просто чтобы дописать или исправить ошибки, которые у вас были. На результаты раунда это, конечно, не влияет, но все-таки разобраться в своих ошибках нужно.</p>
        
        <p>Кроме того, на этом сайте есть много другой полезной информации. Во-первых, там есть функционал блогов, и пользователи часто пишут различные тексты и статьи на темы, связанные с программированием. На многих страницах сайта справа есть список постов, которые в данный момент обсуждаются. Во-вторых, на сайте есть раздел "тренировки", куда выкладываются задачи многих прошедших олимпиад; их можно самостоятельно решать в учебных целях.</p>
        
        <h4>Полезные ссылки</h4>
        <a href="https://codeforces.com/help">Общая справка по codeforces</a><br>
        <a href="https://codeforces.com/blog/entry/456">Полные правила раундов</a></div>""",
                                    String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>About the Codeforces website</h1>
        <p>If you got here, then you are already pretty good at programming, and it makes sense not only to solve the problems of our course, but also to train more or less regularly. I recommend you to register on the website <a href="https://codeforces.com">codeforces.com</a> (if you suddenly have it open in English, then in the upper right corner you can switch to Russian), study it and from time to time take part in its "rounds".</p>
        
        <p>Namely, "rounds" competitions are regularly held on this site. They happen on average once every one to two weeks (it is not necessary to write each round, but I would recommend you to write rounds at least once a month or a month and a half). These are not some prize-winning Olympiads, etc., it makes sense to participate in them out of interest, and for the purpose of training. Rounds are held according to different rules, below I will describe the most common option.</p>
        
        <p>Firstly, all codeforces participants have a so-called "rating" — an integer showing how successfully you performed at codeforces rounds. If you perform well, your rating will grow, if you perform poorly, then it will fall. The color that your nickname is written on codeforces pages depends on the rating. In addition, all codeforces participants are divided into two "divisions" by rating. You initially participate in the second division, if your rating becomes high enough (1700 and above), then you move to the first division.</p>
        
        <p>Rounds are usually held separately by division. Two parallel rounds are most often held — for the first and for the second division; the tasks partially overlap, partially differ. There are combined rounds for two divisions, there are rounds only for the second division. There are rounds according to very special schemes and rules. Most rounds are "rated", i.e. the results of participation in them affect your rating, but there are also "unrated" rounds. Usually, the rating of the round is warned in advance.</p>
        
        <p>The most common rounds are held according to the following rules. To participate in the round, you need to register for this round in advance (i.e. not just register on the website, but also click the special "register for the round" button), usually registration for the round ends 5-10 minutes before the start of the round. The round lasts 2-2.5 hours. You are offered 5 tasks, ordered by complexity (at least as the authors of the tasks think). Each task has its own cost, which determines the number of points that you will receive if you successfully solve this task. Simple tasks have a low cost (usually from 500), complex tasks have a high cost (usually 2500). (These scores are not directly related to the rating scores.)</p>
        
        <p>You can solve problems in any order (although usually everything is solved from simple to complex), in any valid programming languages. When you think you have written a solution, you can submit it for review (similar to how you do on our website). Your task will be tested on so—called "pretests" - some set of tests that is not necessarily complete (i.e. you can pass all the pretests, even if your solution is not quite correct). If your decision has not passed at least one pretest, it is not accepted, and you are informed about it. If it has passed all the pretests, then it is "accepted for final verification", which will take place at the end of the round.</p>
        
        <p>If your decision has not passed the pretests, you can retake it. If it has passed all the pretests, you can still retake it — if, for example, you have found a mistake. At the same time, you will subsequently receive 50 penalty points for each extra parcel.</p>
        
        <p>The cost of the tasks drops over time, dropping to about half of the initial cost by the end of the contest. Accordingly, if in the end it turns out that you have solved the problem, then you will receive as many points as it was worth at the time of your last parcel, minus 50 points for each previous parcel. During the round, you can watch its current results, i.e. who has decided what at the moment.</p>
        
        <p>In addition to all this, there is a system of "hacks". Namely, if your solution for some problem has passed the pretests, you can "block" it (by clicking on the corresponding button in the interface). After that, you can no longer resend this task, but you get the opportunity to view the source codes of other participants for this task (only those that have passed the pretests). In order for you not to mess around in a huge table of results, all participants are divided into "rooms" in a pseudo-random way before the round, and you can view the decisions of only participants from your room. To view the participant's uod, double-click on the corresponding cell in the results table of the room.</p>
        
        <p>The purpose of viewing the solution is to try to find errors in it. If you think you have found a bug in the solution, you can come up with a test on which you think this solution will work incorrectly, and send this test to the system — try to "hack" this solution. The system will immediately check this solution on your test and if it really does not work, then you will get plus 100 points, if you make a mistake, then you get minus 50 points. In case of successful hacking, the participant who was hacked will see it, and (if he has not blocked the task yet) will be able to send his solution. If he has already blocked the task, then he is out of luck. Accordingly, similarly, other participants can hack your solutions; at the same time, of course, you do not see the test with which you were hacked.</p>
        
        <p>When viewing a solution, you cannot copy its text anywhere; you must look at the code purely with your eyes.</p>
        
        <p>After the end of the round time, all solutions are retested on a full set of tests. Now, if you still had the wrong decision, then it almost certainly won't pass any of the full-fledged tests. After that, the final results are calculated. Namely, for each task that you have passed, you are awarded points corresponding to the cost of the task at the moment when you sent the last solution to it, minus 50 points for each previous parcel for this task. For those tasks that you have not passed, penalty points are not awarded. The results of hacks are added (100 points for a successful hack, 50 points for an unsuccessful one), and your final score is obtained, which determines the place you eventually occupy. The growth of your rating depends on this place.</p>
        
        <p>After each round, brief reviews of the tasks are published (on the same day or in a day or two). I recommend you to read them. In addition, after the end of the round, you can still "finish solving" — send tasks for review just to add or correct errors that you had. Of course, this does not affect the results of the round, but you still need to figure out your mistakes.</p>
        
        <p>In addition, there is a lot of other useful information on this site. Firstly, there is a blog functionality, and users often write various texts and articles on topics related to programming. On many pages of the site on the right there is a list of posts that are currently being discussed. Secondly, there is a section "training" on the site, where the tasks of many past Olympiads are laid out; they can be solved independently for educational purposes.</p>
        
        <h4>Useful links</h4>
        <a href="https://codeforces.com/help">General help on codeforces</a><br>
        <a href="https://codeforces.com/blog/entry/456">Full rules of rounds</a></div>"""), {skipTree: true})


export default codeforces = () ->
    return {
        topic:  topic(
            ruen("Про сайт codeforces", "About the codeforces website"),
            null,
        [module17501(),
            link("http://blog.algoprog.ru/other-contests/", "Как решать другие контесты и codeforces"),
        ], "codeforces"),
        count: false
    }