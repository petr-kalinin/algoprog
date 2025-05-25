import epigraph from "../lib/epigraph"
import label from "../lib/label"
import level from "../lib/level"
import page from "../lib/page"
import {ruen} from "../lib/util"

module20927_23 = () ->
    page(
        "For teachers and parents", 
                                         String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>For teachers and parents</h2>
        <p>I've already written about this in the FAQ, but just in case I'll repeat it here. I consider your children's classes here as voluntary, and I'm not going to demand anything from them, force them, etc. If a student does not want to study, or cannot force himself, I will not demand anything from him. I simply don't have any channel of influence on him.</p>
        
        <p>But you can influence the student, so if you want there to be some result from classes, then watch how your student is engaged. On the left, in the site menu, there are "Rankings", where you can track the progress of each student. The student can also show you what problems he tried to solve, what was the result of his attempts, etc. There is also a "Rankings by week" table, it indicates who reached what level, as well as by week who solved how many problems. The color of the cell in the "Rankings by week" indicates how good the result was shown by the student in the next week: bright green - very good, light green — average, white — did not even try anything at all. Finally, you can always contact me.</p>
        
        <p>A separate appeal to teachers: it often happens that strong schoolchildren are simply bored at school computer classes. If your student is engaged in this course, allow him to solve problems during the lesson, read the theory of this course! And, of course, if you have strong students — tell them about this course!</p>
        </div>""")

module20927_25 = () ->
    page(
        "\nAbout independence", 
                                        String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>About independence</h2>
        
        <p>Separately, I want to write you about your independence. I expect that when working in the course you will show the ability to work independently enough. I want you not only to stupidly write what I told you, but also to be able to think for yourself.</p>
        
        <p>This means, firstly, I will not rush you or force you to solve problems. If you want to solve, then solve, if you don't want, well, don't solve, it's easier for me — I'll have less to check. I will not stand over your soul and demand something from you.</p>
        
        <p>Secondly, do not expect that <i>absolutely everything</i> that you may need to solve problems will be reflected in classes or in theoretical materials on the site. It is quite possible that in some problems you will find that something is required that was not in theory. It's not scary. You can always ask me, but it's better to first investigate the question yourself (in your favorite book, or on the Internet), and if it doesn't work out, then ask me. I will not eat you for such questions, on the contrary, I will be very happy if you see that something additional is required in some problem, and you can clearly ask what exactly you need.</p>
        
        <p>Thirdly, if you didn't understand something in class, in my comments on your solution, in theoretical materials or anywhere else; or if you don't understand why your program doesn't work, then just contact me and ask. Do not expect that I will explain everything to you in great detail the first time or that I will write you super-detailed comments on solutions. I explain and write just with the expectation that if you do not understand something, then you will ask again.</p></div>""")

module20927_9 = () ->
    page(
        "\nInstructions for those who are here for the first time (or \"What should I do to start studying?\")", 
                                                                                                                  String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Instructions for those who are here for the first time</h1>
        <ul>
        <li><a href="/register" onclick="window.goto('/register')();return false;">Register on the site</a>. </li>
        <li>Contact me using any of the methods listed in the <a href="/material/about" onclick="window.goto('/material/about')();return false;">"About the Course" section</a>. In the letter, specify your name, where you study / work. In addition, write briefly what your experience in programming is, or you will be start studying "from scratch".</li>
        <li>Read, or at least review, all the texts in the "About the Course" section.</li>
        <li>Wait for a response and further instructions from me.
        </li>
        </ul></div>""")

module20927_3 = () ->
    epigraph("There are nine and sixty ways of constructing tribal lays,\nAnd every single one of them is right!", 
                                                                                                                       String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><div style="text-align:right;width:100%;padding-bottom:2ex;"><i>There are nine and sixty ways of constructing tribal lays,<br>
        And every single one of them is right!</i><br><br>
        Rudyard Kipling. In the Neolithic Age<br></div>
        
        <p>Each problem has a lot of solutions, and many of them are correct. One should not expect that every problem has a single correct solution; there are better solutions, there are worse solutions, but there are almost always two or three significantly different solutions, which are all very good, and it is difficult to choose the best one. Be prepared for this, be prepared to see these different solutions and different approaches.</p>
        
        <p>In particular, if you have a bug in the program, then there are usually many ways to fix it. Therefore, do not be surprised if you ask me how to fix the error, and I offer you several ways to fix it.</p></div>""")

pay = () ->
    page(
        "Cost of the course and and payment process", 
                                                   String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix">
        <h1>Cost of the course and and payment process</h1>
        
        <p>The course is for-fee. More precisely, actually all the materials in the course are free. Some of them are on the website informatics.msk.ru in the <a href="https://informatics.msk.ru/course/view.php?id=1135">corresponding section</a> (in Russian), you can study there for free. I charge money for adding you to the summary rankings, reviewing and commenting on your solutions, answering your questions, etc., as well as for access to the "Good Solutions" and "Find a Bug" sections.</p>
        
        <p><b>The cost the course is 5000 Russian rubles per month.</b></p>

        <p>Payment is not necessarily tied to the 1st of the month; for example, you can pay for the course from the 20th of one month to the 20th of another month.</p>

        <p>For new students, the first week of study is free.</p>
        
        <p>The cost of the course is fixed at the time of the first payment and for life.</p>
        
        <h2>Payment</h2>
        <p>You can pay for the course with any bank card <a href="/payment" onclick="window.goto('/payment')();return false;">on the website</a>.</p>
        <p>Most bank cards from most countries should be supported. If you encounter problems, please contact me, we can discuss other payment methods.
        If you pay with a non-Russian bank card, the payment currency may be different, not rubles (the sum to pay will be converted according to the official exchange rate of the Central Bank of Russia), and an additional fee of 10% may be collected. The exact fee will be shown on payment page.</p>
        
        <h2>Rules about breaks and refunds</h2>
        <p>The cost does not depend on how active you are in the course (if you solve a lot, then I will spend more time on you than if you solve a little, and you pay the same amount). Moreover, many people, of course, do not study every day, but it is rather strange to take money only for those days when you did study, because it punishes active students. Therefore, the unit of payment is a month, and even if you do not study for a small number of days, these days must still be paid. The formal policy is as follows:</p>
        <ul>
        <li>If you prolong the payment no later than 6 days after the end of the previous paid term, the new paid term is calculated "end-to-end" to the previous one, i.e. not from the date of payment, but from the date of the end of the previous term. If you prolong the payment later than 6 days after the end of the paid period, the new paid period is calculated from the date of payment.</li>
        <li>If for objective unforeseen reasons you could not study in the course for more than 5 days in a row (broke your arm, etc.), then I will refund you the money for the entire period when you could not study*. Predictable things like trips, exams, etc. do not count here.</li>
        <li>If for whatever reason you did not study for more than 10 days in a row, then I will refund you half of the money for this period*.</li>
        <li>If you warn me in advance that you will not be able to study for more than 10 days in a row, then I may refund your money for this period.</li>
        <li>Of course, if for some reason I could not check your submissions and respond to your emails for more than 5 days in a row, then I will refund you for the entire period*.</li>
        </ul>
        <p>* Any refunds are discussed no later than 14 days from the end of the period for which you request a refund. If you contact me later, I have the right to refuse.</p>
        <p>Of course, in any case, instead of a refund, if you want, I can simply extend the paid period for a period corresponding to the refund amount.</p>
        </div>""", {id: "pay"})

module20927_13 = () ->
    page(
        "\nAbout accepting and ignoring solutions", 
                                                           String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix">
        <h2>About accepting and ignoring solutions</h2> 
        <p>I will review, if possible, all your solutions, and comment on them in one way or another. I will assign a new status to the successfull (OK) solutions that I review: 
        </p><ul>
        <li>"Accepted" — the problem is written more or less normally, hooray. On the page of viewing the code of your submission (by clicking the submission row) in a special tab you can see my comments. If there is no comment there, then the problem has been solved very well. If there is a comment, it usually indicates what can be improved.</li>
        <li>"Ignored" — I didn't like something very much in your code. On the page of viewing the code of your submission (by clicking the submission row) in a special tab you will see my comments explaining exactly what I didn't like. Fix it and resubmit.</li></ul><p></p>
        
        <p>If you don't understand the comment, ask me, I'll explain in more detail.</p>
        
        <p>Submissions with the status "Accepted" are marked green in the rankings.</p>
        
        <p>Submissions with the status "Ignored" are marked blue in the rankings.</p>
        
        <p>Do not treat the "ignores" as a mockery of you. I will try to ignore only those programs that can be improved quite significantly (for example, by significantly reducing the amount of code). Remember that your goal is not only to write a program that will pass all the tests, but also to learn how to program in general. In fact, I put "Ignored" when I think that the comment I am writing to your submission is so important that you should definitely read it; "ignore" is a way to draw your attention to a comment.</p>
        
        <p>The fact that you managed, even if not in the most optimal way, to write a program and pass all tests — it is very cool, but it will be even cooler if you learn and understand how the same can be done even easier. Consider that in most problems, writing a program so that it passes all the tests is, roughly speaking, 70% success, but getting it "Accepted" is the remaining 30%.</p>
        
        <p>You can also view all comments (including those to the accepted submissions, and even to unsuccessful ones) in the right column on the website, and in the Comments section in the left menu.</p>
        <p><a href="https://blog.algoprog.ru/why-ignore/">Read more about which solutions I ignore (in Russian).</a></p>
        </div>""")

module20927_39 = () ->
    page(
        "\"Internship\" at the algoprog", 
                                          String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>"Internship" at the algoprog</h1>
        <p>What do most normal programming students do in the summer? They work as interns in IT companies. Schoolchildren are usually not invited to such internships, and it is usually difficult for schoolchildren to participate in internships.</p>
        
        <p>So I thought, why is algoprog worse than IT companies? And I decided to organize the possibility of some kind of analogue of internships on the algoprog. Namely, if you want, you can participate in the development of the algoprog platform itself. If you've always wanted to add some feature to the algoprog, then you can do it. Or I have a list of things for you that I've been wanting to do on algoprog for a long time, but I still don't have time, and you can do them.</p>
        
        <p>This, of course, will be quite different from the usual problems that you solve on the algoprog. You will have to understand the rather voluminous already existing (and very dirty) code of the algoprog, you will have to understand a programming language that is probably unfamiliar (Coffeescript, but do not be afraid — it is simple and at first very similar to python), you will have to deal with a lot of technologies that you may not have worked with yet (git, MongoDB, node.js, React, a little Redux), you will have to deal with HTML and browser Javascript, you will have to Google and read a lot - but I believe that if you absolutely confidently solve at least problems of levels 1A and 1B, and are not afraid to figure it out yourself with the problems that arise, then you can quite deal with all this.</p>
        
        <p>The source code of the algoprog is: <a href="https://github.com/petr-kalinin/algoprog">https://github.com/petr-kalinin/algoprog</a> . The list of improvements that you can do is: <a href="https://github.com/petr-kalinin/algoprog/issues">https://github.com/petr-kalinin/algoprog/issues</a> , or you can discuss with me and offer something of your own.</p>
        
        <p>Unlike classic internships, I will not demand any regularity from you in your work (well, actually, as with ordinary problems on the algoprog), and I will not pay you money :) - but I promise that I will delve into what you are doing and help. And you will contribute to the development of the algoprog, and get a lot of new diverse experiences.</p>
        
        <p>In addition, unlike classic internships, I will not be able to pay as much attention to you as a mentor usually pays to an intern in IT companies. You will have to figure out a lot on your own, I will guide your actions rather than give specific detailed instructions. Be prepared for this.</p>
        
        <p>In general, if you want to participate in this, write. It applies to everyone who is engaged in the algoproge (not necessarily schoolchildren) and has a level of at least 1B. Summer only (from May to August inclusive).</p></div>""", {id: "internship"})

work_with_site = () ->
    page(
        "\nWorking with the site, sending solutions and viewing my comments", 
                                                                                 String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>Working with the site</h2>
        <h3>Theoretical materials</h3>
        <p>Some theoretical material is presented on many topics on the site. Before you start solving problems, read the relevant theory.
        For example, go to level 1A (inside level 1), there is a section "Arithmetic operations", and in this section there are two links — "Getting started with Python and Wing IDE" and "Problems on arithmetic operations". Here "Getting Started with Python and Wing IDE" — this is the relevant theory (in this case, the very basics of working on python, including basic arithmetic operations). Read this theory before solving the corresponding problems. (Of course, if you know the basics of your programming language, then it makes no sense to read the most basic theory, but then you probably start with the following topics, or at least skim the theory).</p>
        <h3>Problems</h3>
        <p>The main thing you will do in our classes is to solve problems. Most problems will require writing a program that reads (from the keyboard or from a file) some data, calculates new data from it, and displays the result on the screen or saves it to a file.</p>
        <p>You can (and should) send the program you have written for verification. This site provides an opportunity to automatically check your programs — you immediately (usually within a couple of minutes) get the result of the check: your program is working correctly or not. In addition, I will see all your attempts that you send to the site, and I will be able to comment on them, write comments, etc., and you will be able to see these comments and improve your programs based on them.</p>
        
        <h3>Sample problem</h3>
        <p>Go to level 1A (inside level 1). There is a link "Problems for arithmetic operations". Go in there. You will see a list of problems: "Pears", "Pears too", etc., up to "After and before". This is a set of problems (they say "contest" in short) that you are invited to solve in order to consolidate knowledge on the first topic of the course — arithmetic operations.
        </p><p>All the names of the problems are links, they open the actual problem. Open the problem "Pears". You can see her condition: "N friends have K pears. They want to divide these pears among themselves so that everyone gets as much as possible, but at the same time so that all the guys have the same number of pears. How many pears will each have?" Below is an example: when entering data "7 26", the program should output "3".</p>
        <p>The problem condition clearly describes what your program should do: for any values of N and K, it should calculate and output the answer to the problem. In more serious problems, the condition always specifies restrictions on the permissible N and K, but in the problems for beginners on this site it is considered that N and K are "reasonable" (in particular, they are fit into <code>int</code> data type in C/C++); "reasonableness" in this case also includes the fact that both numbers are positive.</p>
        <p>The example is only needed to verify that you correctly understood the statement, the format of the input data, and to help you test the program on the simplest test. However, your program should work not only on the test from the example, but also on other valid tests.</p>

        <h3>Writing a solution</h3>
        This problem is solved quite easily. Of course, we need to have two variables, N and K, read them from the keyboard, and output the incomplete quotient of dividing K by N (note that it is K by N, not N by K!). The program will look like this:
        <pre>n = int(input())
        k = int(input())
        print(k // n)</pre>

        Pay attention to the following features (it may not agree with your textbook — you need to do as it is written here, and not in the textbook. Perhaps you won't understand some of the things described here - then just skip this point).
        <ul>
        <li>We don't output any "prompts" like <code>print("please enter N")</code>. The problem condition clearly states what exactly our program should display on the screen, and there is nothing said about the fact that it is necessary to display prompts. Therefore, any extra output to the screen will be considered as a violation of the output format.</li>
        <li>There are no "fool checks", for example, there is no check "what if N = 0?", or "what if they didn't enter a number?". Similar to the previous one, this is not required in our problems. In more serious problems, there will be restrictions on the permissible values of N in the condition, and no one will test your program with N that does not meet these restrictions. In this problem, it is assumed that N>0 is always.</li>
        <li>We don't put an empty <code>input()</code> (or <code>getch();</code> in c++) or other delay at the end of the program. This is also not required; the information displayed on the screen is still saved and can still be viewed.</li>
        <li>We calculated and immediately output the answer without saving it to an intermediate variable. It was possible to save:
        <pre>ans = k // n
        print(ans)
        </pre>
        In this simple program, it is easier to output immediately, but if the expression is more complicated, then you can save it.</li>
        </ul>
        <p>Save this program to some file. Remember both the file name and the directory (folder) where you saved the file.</p>

        <p>Now test the program. Run it and try different tests.</p>

        <p>To start, enter the test from the example: "7 26" (in different lines, like in the example) and make sure that it outputs 3.</p>

        <p>In this problem, the answer to each test is uniquely determined (for example, the answer to the example from the statement can only be 3). There are problems when there may be several correct answers for each test, in such problems the condition usually says "if there are several solutions, output any" or there is some similar phrase. In this case, your program is not obliged to give an answer that exactly matches what is specified in the example — it is enough that it is one of the correct ones. Similarly, in the future, when your program will be tested on the website (see below), any of the correct answers for each test will be allowed.</p>

        <p>Come up with some more examples for this problem. Try to make them diverse: so that there are different N, K, and different answers. For example, enter "5 25" and check that the answer is 5. Come up with a few more examples yourself. Important: before entering each example into the program, first calculate the answer in your mind, and only then run the program and check that it has output exactly what you expected. Try to always know the answer to your example BEFORE starting the program.</p>

        <p>If the program is written correctly, then it will work correctly on your tests. Then it can be submitted for verification to the site (we say "submit / send for testing to the testing system" or simply "submit to the system").</p>

        <h3>Sending for testing</h3>
        <p>Go back to the page with the problem statement. Below the statement there is a section "Submit a solution" (it is only there if you are registered on the site and logged in). Click the file selection button and select the file with your solution. Make sure you select the file .py or .cpp (with source code), not .pyc, .o or .exe (already compiled program)! Make sure that the correct language is selected in the drop-down list next to it, and click the "Send" button.</p>
        
        <p>Your program is sent to the server, which checks it by running on several test cases. These test cases are unknown to you, but they are always the same in each specific problem (i.e. if you send several times, the test cases will be the same each time). So, the testing system will run your program several times, each time it will simulate keyboard input of the values N and K from the next test cases, and check that your program outputs the correct answer.</p>

        <p>Under the submission form there is a table listing all your attempts (also called "submissions" or "submits") for this problem. Initially, of course, there is no table there. After you have submitted your solution, it will appear in this table. The "Status" column displays the result of testing your program. Immediately after you have submitted the program, you can see there "Compiling" or "Testing", which means that your problem is being tested. The table is updated automatically, wait until the final result of the check appears in the "Status" column.</p>

        <p>The main results of the check that you can see:
        </p><ul>
        <li>OK — your program has passed all the tests correctly, hooray!</li>
        <li>Compilation error — your program was not compiled</li>
        <li>Partial solution — your program didn't pass all the tests (maybe it didn't even pass any). So, your program is not working quite right (or works completely wrong), try to find mistakes.</li>
        <li>There are also "Accepted" and "Ignored" statuses, but they are not set automatically, see about them below.</li>
        </ul>

        <p>You can click on each line in the submission table, after which a window with detailed information about the submission will open. Firstly, there will be the full code of your program, so you can always check whether you have sent exactly what you wanted; if you had been solving problems from school, then when you come home, you will be able to see the codes of all your programs, etc.</p>

        <p>Secondly, in the window that opens there is a tab "Protocol", where the test protocol of your program is displayed. If your program was not compiled (the status is "Compilation error"), then there will be a compilation protocol: errors found in the program will be indicated. If your program was compiled, then there will be a test protocol: for each test, information will be provided about whether this test passed (OK) or not. There are only 8 tests in the problem "Pears", so there should be 8 rows in the table. If your submission has received the status "OK", then all 8 lines will be OK; otherwise, some tests will have a different status (it is usually clear from the name of the status what this means).</p>

        <p>Thus, you can see which (by numbers) tests you have passed and which have not. But you can't find out the contents of the test (in our problem, which N and K are exactly there). This is done so that you learn to test your solution yourself and find examples on which it does not work, and not consider the testing system as a magic box that gives you examples on which your program does not work. Therefore, if your program does not work, then try to find the examples on which it is wrong. If you can't find them, then contact me, we'll try to figure it out together. As a last resort, I have access to all the test data, so if I can't find an error just by looking at your program's code, I can see what kind of test your program doesn't work on.</p>

        <p>But in general, try to check the problem before sending it to the system (and we will learn this separately). Treat failed attempts as a real failure, and try to make as few failed attempts as possible. In general, at many programming contests you will have only one opportunity to submit the problem, and if it does not pass some tests, then you will no longer have the opportunity to improve!</p>

        <h3>Accepting and ignoring submits, comments on submits</h3>
        <p>I will review all your solutions: if I have time, all submissions in general, including unsuccessful ones, or if I have little time, and there are a lot of submissions, then only submissions with the OK status.</p>

        <p>In successful submissions, I will review your code for the following:
        </p><ul>
        <li>First, I will look to see if there are any errors in the code that the tests of the testing system did not catch. It happens that there is some completely unexpected error in the code, and the testing system may miss it (although the tests in the testing system are usually well prepared, and as a rule all errors in the code manifest themselves during testing) - I will see if you have such errors.</li>
        <li>I will also look to see if I have any comments on the code, even if they are not errors, but are general wishes. For example, maybe something can be done easier, or something should be done differently, etc.</li>
        </ul>
        <p>If I have any comments or comments on your program, I will write them and you will be able to see them. Firstly, they will appear on the site in the right column in the "Comments" section; secondly, in each submission, in the window opened by clicking the submit link, there is a special "comments" tab; finally, there is a separate Comments section in the lefthand menu. Accordingly, as soon as I comment on your package, you will see a comment. Usually I try to view all the submissions during the day, although sometimes there are long delays, up to several days.</p>

        <p>In addition to actually writing a comment, I make a decision on each of your submissions — either I accept this submit (albeit with small comments), or I will require you to rewrite this submit taking into account my comments. In the first case, I change the status of the submission to "Accepted" (i.e. you will see exactly "Accepted" instead of "OK" in the table with your submissions), in the second case I change the status to "Ignored". Accordingly, in the first case, just take note of the comments that I wrote (and it happens that I do not write any comments), although you can rewrite the solution if you want. In the second case, be sure to rewrite the solution taking into account these comments.</p>
        <p>(<a href="https://blog.algoprog.ru/why-ignore/">Read more about why I ignore solutions</a> (in Russian).)</p>

        <p>In the summary table, the "OK" solutions (i.e., which I haven't looked at yet) are displayed with a yellow background, the "Accepted" solutions (i.e., which I have accepted) are displayed with a green background, ignored solutions are not taken into account in the total number of problems you have solved, just the corresponding problem in the summary table is displayed with a blue background.</p>

        <p>I will also try to write comments on your unsuccessful submissions — to point out an error or advise where to look for it, etc. Of course, I will not always write them as soon as I see your attempt, and I will not always fully report the error found — after all, it will usually be useful for you to find the error more-less independently, I will try to give you suggestive advice (but, of course, it depends on the error). In general, if you tried to do a problem, but it does not pass the tests, then perhaps within a day I will write you a tip in the comments to your submission.</p>

        <p>Sometimes I may not have time to review all your unsuccessful submissions, or I do not write a comment for some other reasons. In that case, if you want to get a comment on any of them, just contact me.</p>

        <h3>Good solutions</h3>
        <p>After I accept your solution (I set the status "Accepted"), you have access to "good solutions" for the corresponding problem — on the problem page, above the form for submitting the solution, a link to "good solutions" appears.</p>

        <p>"Good solutions" are several (up to 5) solutions that were submitted by other students of the course, and which, in my opinion, are written quite well and can be considered an example of solving this problem. Watch them, especially for those problems where I have accepted with any comments (but in general it is useful to watch "good solutions" and for all accepted problems in general). Compare the "good solutions" with your solution, perhaps you will see that something can be done easier, or even find other useful ideas.</p>
        
        <p>I try to keep the balance of different languages in the "good solutions" as much as possible (i.e., as a rule, there are solutions in different languages among the "good solutions"). But look at the solutions in your language, and in other languages that you don't even know — as a rule, you can understand the algorithm even in languages that you don't know at all. On the other hand, you can also find some interesting purely linguistic subtleties and techniques for your language in "good solutions".</p>

        <p>In addition, often in "good solutions" I show different approaches to solving the problem, often there are generally different algorithms. If you see that a "good solution" is very different from yours, it is useful to understand how it works in general.</p>

        <p>At the same time, understand that in fact, hundreds of solutions have already been submitted for many problems on the site, and in fact there are dozens of "good" ones, if not more. You see a maximum of five of them, simply because there is no point in reading dozens of more or less identical solutions. You will see some five of them which were lucky that I marked them as "good", but this "luck" is often determined by chance, well, and the principles mentioned above about the diversity of languages and approaches. That is, you don't see the top-five best solutions, but five random ones from among those that are sufficiently good.</p>

        <p>Therefore, do not assume that if your personal submit did not get into the "good" ones, then it is worse than the "good" ones. It can be just as good, or even something better than the "good" ones, it's just unlucky. If you see that the "good" solutions are written as cleanly and clearly as yours, then yours could also be "good". Conversely, if your solution is in the "good", it does not mean that it is much better than all the others :) For the same reason, the authors of "good solutions" are not signed.</p>

        <p>On the other hand, if you have looked at the "good solutions" and think that your solution is noticeably better than all the "good" ones, write to me, maybe I will add your solution to the "good" ones. (Although I usually designate a solution as "good" at the same time as I count it, so if your solution is really noticeably better than other good ones, as a rule, I will make it "good" even before you can see "good solutions" :) .)</p>

        <h3>Rankings tables</h3>
        <p>All your submissions for our problems are displayed in rankings tables, links to which are in the site menu. Namely, each cell in the main part of this table indicates the statistics of submissions from a particular student for a specific problem. If there is a "+" sign in the cell, it means that the problem was done successfully ("OK" or "Accepted"), if "-" — it means that the person tried to pass the problem, but did not pass all the tests. The number after the icon (if any) indicates the number of unsuccessful attempts (if any). For example:
        </p><ul>
        <li>An empty cell indicates that the student did not attempt on the problem at all;</li>
        <li>"+" indicates that the problem was solved successfully on the first attempt;</li>
        <li>notation "-" does not happen;</li>
        <li>"+2" means that the problem was solved on the third attempt (two unsuccessful attempts and then a successful one);</li>
        <li>"-2" means that there were only two unsuccessful attempts on the problem and that's it.</li>
        </ul><p></p>

        <p>The background of the cell indicates the status of the problem relative to the verdicts "Accepted" and "Ignored":
        </p><ul>
        <li>Yellow background — status "OK", i.e. I haven't looked at this problem yet;</li>
        <li>Green background — status "Accepted";</li>
        <li>The blue background indicates the status "Ignored", while the ignored attempt itself is considered neither successfull nor unsuccessful.</li>
        </ul><p></p>

        <p>The last two columns of the table indicate the total number of solved problems and the total number of unsuccessful ("penalty") attempts (only those problems for which the correct program was eventually obtained are taken into account, ignored attempts are not taken into account). The table is sorted by the total number of solved problems, and with an equal number of solved problems — by the number of penalty attempts.</p>

        <p>The table also has the following feature: only students who meet two requirements at once appear in it: first, I have to activate their account, and secondly, the student must have at least one attempt to complete the problem. Therefore, if you have not tried to take anything yet, do not be surprised that you are not in the table. If you have already tried to take something, but you are not in the table, then write to me - perhaps I forgot to activate you.</p>

        <p>Similarly, problem sets (contests) they appear in the summary table only when at least someone submits some solution for some problem of this contest.</p>

        <h3>Terminology</h3>
        Above I have already introduced some specific terminology that is used in programming contests, just in case I will repeat it here:
        <ul>
        <li>A contest is any set of problems that is somehow grouped and separated from the rest. Within the contest, the problems are usually numbered (1, 2, 3, ... or A, B, C, ... etc.) It can be a separate round of some competition, or a set of problems for some class or on some topic, etc. As part of our classes, we call a "contest" a set of problems available on each individual link from a page of the appropriate level. For example, "Problems on arithmetic operations" is a separate contest.</li>
        <li>A submission (synonyms: attempt, submit) is your separate attempt to submit a problem to the testing system; also the program that you submitted in this attempt.</li>
        <li>A penalty attempt (usually in the context of a summary rating) is an attempt that did not pass all the tests.</li>
        <li>The test is a separate test case prepared by the authors of the problem in order to test your programs on it. Usually, for each problem, the author of the problem prepares from 5 to 60 tests, and the programs that you submit for verification are checked in turn on all these tests. On our site, in order for the attempt to be considered successful, it is necessary that the program passes all the tests, i.e. it gives the correct answer to all the tests. (Other contests may have different rules.)</li>
        </ul></div>""")

module20927_7 = () ->
    page(
        "FAQ", 
                    String.raw"""<h3>What is this course?</h3>
        <p>This is a course on algorithmic programming (algorithms, data structures, etc.)</p>
        
        <p>It is primarily designed for schoolchildren and as a preparation for school programming contests (and many materials in the course are written exactly as for schoolchildren), but also everyone can (and do) study: students, university graduates, etc. Classes for Nizhny Novgorod schoolchildren are free, for everyone else — paid.</p>
        
        <h3>What is being taught here?</h3>
        <p>The main topic is algorithmic programming. Starting from the basics of programming, and further into algorithms and data structures.</p>
        
        <h3>What is NOT taught here?</h3>
        <p>We do not deal with "technical" issues:</p>
        <ul>
        <li>Creating user interfaces, buttons, windows, etc.</li>
        <li>Programming for specific platforms: creating web applications, programming for Android, iOS, etc.</li>
        <li>Using various frameworks, libraries, etc.</li>
        </ul>
        <p>We will study the algorithms that underlie many such programs (we will not discuss how to make the "sort alphabetically" button, but we will discuss how to implement sorting when there is already a list of objects to sort).</p>
        
        <h3>Are you really going to teach?</h3>
        <p>Yes and no. The format of the online course implies that you will study a significant part of the material yourself. I will rather guide you, advising you where to look at this or that question, on which problems to debug skills, and I will also comment on your programs quite actively. In addition, you can always contact me (contacts in the "About the course" section) and ask any question.</p>
        
        <h3>What is the programming language?</h3>
        <p>Generally speaking, whatever you want, of those that allow you to write console applications and are supported by this site. These are C++, Java, Python, C#, PHP, Perl, Kotlin, etc. </p>
        
        <p>At the same time, if you don't know any programming language yet, then I recommend Python. On the course page there are materials for beginners in python. If you know any of the languages listed in the previous paragraph, you can use it; but in general, all advanced topics (starting from level 2) do not depend on the language.</p>
        
        <p>Personally, I know C++ and Python best of all; I can help you with these languages in sufficient detail. In other languages, I will not be able to tell you about various subtleties of the language, although, as experience shows, this is not very important for algorithms.</p>
        
        <h3>And what initial knowledge is required?</h3>
        <p>In programming — from none and above. In general, the online format allows you to implement almost individual training (i.e., each participant of the course is engaged in his own rhythm and mode), so I expect people with a wide range of initial knowledge here: from junior schoolchildren who are just beginning to program, to already professional programmers who want to improve their knowledge in the field of algorithms.</p>
        
        <h3>What should I do to start studying?</h3>
        <ul>
        <li><a href="/register" onclick="window.goto('/register')();return false;">Register on the site</a>.</li>
        <li>Contact me using any of the methods listed in the <a href="/material/about" onclick="window.goto('/material/about')();return false;">"About the Course" section</a>. In the letter, specify your name, where you study / work. In addition, write briefly what your experience in programming is, or you will be studying "from scratch".</li>
        <li>Read, or at least review, all the texts in the "About the Course" section.</li>
        <li>Wait for a response and further instructions from me.
        </li>
        </ul>
        <p></p>
        
        <h3>When can I start studying? When does the "next group" start?</h3>
        <p>You can join the course at any time. All the same, students have quite different levels of training, so there is no single program like "this week we are going through this, next week this, and if you missed or learned about the course too late, then wait for the next group or next year".</p>
        <p>The only thing is that during the holidays or in the summer I may have limited access to the Internet, so I may not respond to your letters so quickly, look at your solutions, etc.</p>
        
        <h3>And who are you anyway?</h3>
        <p>I am Petr Kalinin, Ph.D., Senior developer at Yandex, graduate of the Nizhny Novgorod State University. At one time, I actively participated in various programming contests and olympiads: bronze medalist of the International Olympiad in Informatics (IOI) in 2001, gold medalist of the IOI in 2002; as part of the UNN team, I twice participated in the finals of the ACM International Collegiate Programming Contest (ACM ICPC). From 2017 to 2019, I taught at the Yandex School of Data Analysis. I am a student of V.D. Lelyukh.</p>
        
        <p>In one form or another, I have been teaching programming to schoolchildren since I graduated from school in 2002 (I went as a teacher to various summer schools, etc.); this course has been in existence since 2013. Among my students are a number of participants and one winner of the final stage of the All—Russian Olympiad of Schoolchildren in Computer Science (not counting my brother Nikolai, in whose training I also took part not the last time and who is the absolute winner of the final stage of 2013 and twice — in 2013 and 2014 — the gold medalist of the international Olympiad of schoolchildren in computer science).</p>
        
        <p>You can always contact me, contact details are listed in the "About the course" section.</p>
""")

module20927_1 = () ->
    epigraph("Use your head to think!", 
                                            String.raw"""<h2>Use your head to think!</h2>
        <p>The motto of our course is <i>Use your head to think!</i></p>
        
        <p>This means that you have to think all the time when working on the course. You need to think about how to solve certain problems, how to do a lot of other things. You will not have universal recipes that will allow you to solve all the problems — on the contrary, the best, most interesting problems are those where you are required to come up with something.</p>
        
        <p>Moreover, you should always be critical of any information you receive, of anything that is written in textbooks, of anything I tell you or that is written on the course page. Think, try to understand why it is written, why you are advised to do so, and not otherwise. In textbooks, in what other people tell you, and even more so in my materials and advice, there can easily be mistakes, typos, and finally, you may find easier ways to achieve the same — so never take for granted what you read somewhere, always think about and reflect on the information received. It may turn out that in one source you read one information, and in another source something absolutely opposite — think, experiment (see below), and understand how to do better.</p>
        
        <p>Also, don't be afraid to experiment! If you are not sure if something is possible in python/c++/etc., if it ok to write this or that command, whether it will work as you expect — try it: write and check. If you don't remember exactly how to write a command, try several options until you succeed. If you have read completely different information about how to do something in different places, try it and check which method works! Don't be afraid to try, don't be afraid to experiment — this way you will learn a lot more than if you just strictly follow what is written in any textbooks or what someone (even me) told you.</p></div>""")

module20927_35 = () ->
    page(
        "\nAbout the license for the site materials", 
                                                String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h2>About the license for the materials of this site</h2>
        <h3>The source code of the site</h3>
        The source code of the actual site algoprog.org written by me (Petr Kalinin) and is distributed under the <a href="https://www.gnu.org/licenses/agpl">GNU Affero General Public License</a>. You can download the source code from the website <a href="https://github.com/petr-kalinin/algoprog">github.com/petr-kalinin/algoprog</a>.
        
        <h3>Theoretical materials</h3>
        <p>There are various theoretical materials on this site with varying degrees of clarity from the point of view of the license.</p>
        <p>Materials in which the license is explicitly specified are distributed under the license specified in them.</p>
        <p>Materials posted on other sites to which from the site algoprog.org only the link is affixed, are distributed under a license determined by the specified site.</p>
        <p>Materials in which the license is not explicitly specified, but of which I am the author (this is most of the materials posted directly on the site algoprog.org ), are distributed under the <a href="https://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike (CC BY-SA) 4.0</a> license.</p>
        <p>If you are not sure which license applies to a particular material, ask me.</p>
        
        <h3>Problem statements</h3>
        <p>Most of the the problem statements are taken from the website <a href="https://informatics.mccme.ru">informatics.mccme.ru</a> , where they are mostly collected from various contests. The terms of the license for them are not clear.</p>
        </div>""", {id: "license"})

module20927_15 = () ->
    page(
        "\nAbout the level system", 
                                      String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>About the level system</h1>
        <p>All the material in our course is grouped into levels, from the simplest to the most complex. The levels are numbered in consecutive numbers (1, 2, 3, ...), sublevels numbered with letters are also introduced within the level (in level 1 — sublevels 1A, 1B, 1C and 1D, etc.)</p>
        
        <p>Most levels have the following structure: sublevels A and B contain new material, and sublevels C and D (the latter is not always there) — additional problems of increased complexity to consolidate this material. Sometimes in levels C and D there may be particularly difficult problems for the material of significantly earlier levels (for example, in level 5C there may be a difficult problem for the material of level 3). Sometimes there are contests on separate topics in levels C and D, sometimes additional problems in these levels go in random order.</p>
        
        <p>I assume that you will go through the sublevels sequentially, moving to a new sublevel usually when you have "passed" the previous sublevel. Exception: if you have passed some topic in sublevel A or B, and you see a contest of advanced problems on the same topic in sublevel C or D, then you can solve it.</p>
        
        <p>The requirements for the "passing" of each sublevel are indicated under its heading. As a rule, for sublevels A and B it is required to solve all the problems, for levels C and D it is required to solve part (half or a third) of the problems. However, this does not mean that the remaining problems of levels C and D do not need to be solved. I recommend that if you have solved the necessary minimum of problems of levels C and D, go to the next level in order to quickly begin studying a new theory. But at the same time, return regularly to the unfinished problems of the previous levels. It can be estimated approximately as follows: when you move to level 4A, you should have solved half of the problems of level 3C, 3/4 of the problems of level 2C and about 7/8 of the problems of levels 1C and 1D. Similarly, when you move to level 5A, you should have solved half of the problems of level 4C, as well as 3/4 of the problems of level 3C, 7/8 of the problems of level 2C and almost all (with the rare exception of particularly unpleasant problems) problems of levels 1C and 1D. Similarly for other levels.</p>
        
        <p>Please note that in levels C and D, the problems are not always ordered by complexity. Therefore, solve them in the order in which it is more convenient for you!</p>
        
        </div>""")

module20927_37 = () ->
    page(
        "\nAbout the franchise", 
                             String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Franchise</h1>
        
        <p>If you are already teaching someone (schoolchildren, students, etc.) programming, and you want to use the algoprog or its materials in your classes...</p>
        
        <p>...or if you want to start teaching someone on the algprog or using its materials...</p>
        
        <p>... or if you want to use the algoprog engine in your classes by filling it with your own materials</p>
        
        <p>then this text is for you.</p>
        
        <h2>Materials</h2>
        
        <p>If you do not need the functionality of the algoprog, but only <i>materials</i> — theoretical materials, video lectures, problems, etc. — then they are freely available in one form or another. Theoretical materials, the author of which I am, as a rule, are distributed under one or another free license, you can use them. It is usually indicated in the material itself, if the license is not specified there, then ask me. The materials that I am not the author of are taken from other sites, you can usually use them too. Almost all problems are taken from public sites <a href="https://informatics.msk.ru">informatics.msk.ru</a> and <a href="https://codeforces.com">codeforces.com</a>, on both of these sites you can form your courses from the problems available there, etc. Basic (although already outdated) contents of the algoprog are on informatics: <a href="https://informatics.msk.ru/course/view.php?id=1135">informatics.msk.ru/course/view.php?id=1135</a> — actually, the whole algoprog grew out of my informatics course.</p>
        
        <h2>Engine</h2>
        
        <p>The algoprog engine itself is also <a href="https://github.com/petr-kalinin/algoprog">freely available</a>, you can set up your own instance of algoprog and do anything there. (Although, of course, it's not that easy, and I'm unlikely to help you.)</p>
        
        <h2>A separate instance</h2>
        
        <p>I can set up a separate instance of the algoprog for your students, with your materials and problems. This requires a separate discussion, but in principle it is possible. The cost will depend on the necessary work to support the instance, the necessary improvements, and the expected number of students. As a rough preliminary assessment, if no serious improvements are required, and 20-50 students are expected, then the cost of a separate instance will be about 1000 rubles per student per month; if there are fewer students, then the cost, of course, will be higher.</p>
        
        <h2>Classes directly on the algoprog based on the materials of the algoprog</h2>
        
        <p>If you want to do it on the algoprog, then there are the following options. Firstly, your students can register on the algoproge and study as independent students. From my point of view, these will be just additional students on the algoprog, you will be able to organize classes, help students, etc., but you will not have any additional rights on the algoprog itself (you will not be able to view student submissions, etc.). Your students are engaged independently, for them the cost of classes will, of course, be determined <a href="/pay">by the general rules</a>, of course, I will not take money from you (and in general I may not know about you at all :)).</p>
        
        <p>If you want to have additional features — to view students' submissions, comment on them, accept/ignore them, have separate summary tables, then contact me. All of this (as well as other requests from your side) is quite realistic, but requires a separate discussion. As <b>basic</b> options , there are the following:</p>
        <ul>
        <li>Your students are studying in the algoprog on an equal footing with the rest, I check their submissions, comment on them, accept/ignore — and plus you can do the same; there will be separate rankings for your students, etc.<b>As a rule</b>, the cost of such classes for your students will be the same as if they were studying independently. (That is, there is no additional payment for additional functionality, but there are no discounts either.)</li>
        <li>I don't interact with your students in any way — I don't look at their code, I don't accept/ignore them. You do all this, if you want.<b>As a rule</b>, the cost of such classes for your students will be two times less than if they were engaged independently.</li>
        </ul>
        <p>In both variants above, the words "basic" (variants) and "as a rule" are essential. This means that, on the one hand, this is not a public offer — in a particular situation, other conditions and other prices are possible; on the other hand, other options are also possible in terms of functionality and in our interaction with you. Write, let's talk :)</p>
        
        </div>""")

achieves = () ->
    page(
        " \nAbout achievements", 
                              String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>About achievements</h1>
        <p>On the algoprog, each user can earn achievements. Achievements are given out for different things, first of all for successful study on the algoprog itself, as well as for participation in various programming contests. The achievements earned by the user are shown in his profile, also the three most "cool" achievements are shown next to the user's name in rankings, etc.</p>
        
        <p>The full list of available achievements can be viewed <a href="/achieves">here</a>, as well as in the form of source code <a href="https://github.com/petr-kalinin/algoprog/blob/master/client/lib/achieves.coffee">here</a>. In any place (including the link in the previous sentence), you can click on the achievement and see a list of all users who have this achievement.</p>
        
        <p>Some of the achievements are issued automatically, some of the achievements (mainly for the contests) I assign manually. If you think that you should have some achievement, but you don't have it, then write to me. This is especially true for schoolchildren from outside the Nizhny Novgorod region - I can't always keep track of all your contests, so write to me about your contest results yourself.</p></div>""")

tshirts = () ->
    page(
        "About T-shirts", 
                             String.raw"""<h1>About T-shirts</h1>
        <h2>Free T-shirts</h2>
        <p>For achieving certain levels, T - shirts are issued according to the following scheme:</p>
        <ul>
        <li>Reaching Level 3C — violet T-shirt "binary search"</li>
        <li>Reaching Level 5C — blue T-shirt "intersection of lines"</li>
        <li>Reaching Level 7C — orange T-shirt "components of strong connectivity"</li>
        <li>Reaching Level 9C — red T-shirt "cartesian tree"</li>
        <li>Reaching Level 11C — black T-shirt "matching"</li>
        </ul>
        <p>T-shirts are given free of charge to all students studying at the algoprog. I am ready to send them to non-Nizhny Novgorod residents in Russia 
        by a transport company (CDEK or Boxberry) at my expense (with the exception of hard-to-reach regions where neither CDEK nor Boxberry are transported); 
        if you want me to sent a tshirt to a remote region or outside of Russia, then the shipment is at your expense.</p>
        <p>In order for me to give you a T-shirt, contact me. T-shirts come in different sizes, men's and women's. 
        Write the size and style. T-shirts for level 3B are "in stock", most likely, I will just send the T-shirt you need within a few days. 
        T-shirts for higher levels are made to order, within a few weeks.</p>
        """, {id: "tshirts"})

module20927_29 = () ->
    page(
        "\nFormulas for calculating rating, activity, etc.", 
                                                              String.raw"""<div class="box generalbox generalboxcontent boxaligncenter clearfix"><h1>Rating formulas, etc.</h1>
        <p>The rankings tables show the rating, activity, rating on codeforces, weighted rating change on codeforces and weighted number of contests on codeforces.</p>
        
        <h2>Rating</h2>
        <p>(Who cares, the specific code for calculating the rating and activity is <a href="https://github.com/petr-kalinin/algoprog/blob/master/server/calculations/calculateRatingEtc.coffee">here</a>.)</p>
        
        <p>The rating is determined simply by a set of solved problems. Namely, each problem costs a certain fixed number of rating points, determined by the level of this problem.</p>
        
        <p>A Level 1A problem costs $2.5$ rating points. A Level 2A problem costs $2.5^2$ rating points. A level 3A problem costs $2.5^3$ rating points, etc. A level $N$A problem costs $2.5^N$ rating points.</p>
        
        <p>The problems of intermediate levels are worth an intermediate number of points. Namely, the problem of level $N$B costs $2.5^{N+0.25}$ rating points, level $N$C — $2.5^{N+0.5}$, level $N$D — $2.5^{N+0.75}$ points.</p>
        
        <p>Problems from regional olympiads are considered as problems from level 3A. If the same problem exists at several levels, then only the highest level of this problem is taken into account.</p>
        
        <p>When displaying the rating in tables, it is rounded to integers, but when calculating everything is considered real numbers.</p>
        
        <p>Cost table (rounded to two decimal places):</p>
        <pre>          A            B        C         D
         1       2.50       3.14       3.95       4.97
         2       6.25       7.86       9.88
         3      15.62      19.65      24.71      31.07
         4      39.06      49.12      61.76
         5      97.66     122.80     154.41     194.16
         6     244.14     306.99     386.02
         7     610.35     767.48     965.05    1213.49
         8    1525.88    1918.69    2412.63
         9    3814.70    4796.73    6031.57    7584.29
        10    9536.74   11991.82   15078.91
        11   23841.86   29979.55   37697.29   47401.83
        12   59604.64   74948.87   94243.22
        13  149011.61  187372.18  235608.05  296261.43
        </pre>
        
        <h3>Ideology</h3>
        <p>The scores for the problem grow very quickly, because at high levels it is not so important what you have solved at lower levels. For example, if you are already at level 5, then most likely, level 1 problems do not pose any difficulty at all for you. Therefore, it does not matter how much you have solved at level 1. And this is due to the fact that level 5 problems cost much more than level 1 problems.</p>
        
        <h2>Activity</h2>
        <p>(The calculation code is at the same link)</p>
        
        <p>Activity is an indicator of how actively you have been solving problems lately. Every problem that you have ever solved gives its contribution to activity. Each problem has "basic" activity score — this is the square root of the level number. (All level 1 problems have a "base" score of 1, each level 2 problem has a base score of 1.4, etc.) This base score is multiplied by $0.55^{t/\tau}$, where $t$ is the time elapsed since you solved this problems, and $\strut\tau$ is equal to 1 week. For example, if you have just solved the problem, then the base score is taken into account in full. If you solved the problem exactly a day ago, then the base score is multiplied by $0.55^{1/7}\approx 0.92$. If you solved the problem exactly two weeks ago, then the base score is multiplied by $0.55^2\approx.3$. If you solved the problem 8 weeks ago, then the base score is multiplied by $0.55^8\approx.0083$, i.e. this problem is almost not taken into account.</p>
        
        <p>The total activity value for all problems is divided by 0.45, resulting in a sort of average number of "problems" per week.</p>
        
        <p>As a result, only recently solved problems are taken into account, and those that you have solved a long time ago are not taken into account. But at the same time, the decline in this "accountability" is smooth. If you stop solving problems, then your activity will gradually decrease over time (although it will never become exactly zero). In the rankings, activity is displayed rounded to one decimal place, but in fact, activity is a real real number.</p>
        
        <p>In some ranking tables, students whose activity is greater than 0.1 are indicated first, and only then all the others.</p>
        
        <h2>Colour</h2>
        <p>The names of students in the tables are drawn in a color determined by their rating and activity. Namely, the activity determines the brightness of the color (from almost black to saturated), and the rating determines the shade (from purple through all the colors of the rainbow to red). For example, a student with a rating of 1 and activity of 10 will have a bright purple color, a student with a rating of 1 and activity of 0.1 will have a dark purple color, a student with a rating of about 100,000 and activity of 10 will have a bright green color, and with activity of 0.1 — dark green color; red color corresponds to a rating of 4500000.</p>
        
        <p>Specific formula: In the <a href="https://en.wikipedia.org/wiki/HSV_color_space">HSV model</a>, the participant's color has the following components:</p>
        $h = k\cdot \log(r+r_0) + b$<br>
        $v = 0.3 + 0.7 \cdot \log(a+1) / \log(A + 1)$<br>
        $s = 1$<br>
        <p>here $r$ and $a$ are rating and activity, $A=7$, $r_0=200$, and the constants $k$ and $b$ are selected so that the two reference points (rating 600 and rating 4500000) get the correct colors (blue-purple and red).</p>
        
        <p>There are also minor corrections at the edges of possible value intervals. The code is <a href="https://github.com/petr-kalinin/algoprog/blob/master/client/components/UserName.coffee">here</a>.</p>
        
        <h2>Codeforces parameters</h2>
        <p><a href="https://github.com/petr-kalinin/algoprog/blob/master/server/calculations/calculateCfRating.coffee">Code</a></p>
        
        <p>The CF rating is taken directly from CF, updated once a day.</p>
        
        <p>The weighted number of contests is calculated as follows: each contest you write gives a contribution equal to $0.5^{t/\tau}$, where $t$ is the time elapsed since the contest was written, and $\tau$ is equal to 4 weeks. All such contributions are summed up. I.e., a contest just written gives a contribution of 1, a contest written 4 weeks ago — 0.5, etc.</p>
        
        <p>The weighted rating change is calculated as follows: each contest you write gives a contribution equal to $\delta\cdot0.5^{t/\tau}$, where $\delta$ is the rating change in this contest, $t$ is the time elapsed since the contest was written, and $\tau$ is 4 weeks. At the same time, the very first written contest in life is not taken into account, because there a rating change is a meaningless thing.</p></div>""", {id: "about_rating"})

about_find_mistake = () ->
    page(
        "About the \"Find a bug\" section", 
                                          String.raw"""<h1>About the "Find a bug" section</h1>
        <p>When you have solved a problem and received an "Accepted" for it, you have the opportunity to look for bugs in the submits of other students on this problem. Namely, a link "Find an bug" appears on the problem page, which opens a list of specially selected incorrect solutions to this problem.
        (Of course, the link does not appear in every problem, but only in those problems where there are such specially selected solutions.)
        There is also a section in the site menu "<a href="/findMistakeList">Find a bug</a>", where there are links to all solutions in which you can look for errors
        (not all of these solutions are available to you — solutions are available to you only for those problems for which you received a "Accepted").</p>

        <p>For each of the solutions in which you need to find an error, it is known that the error can be corrected by making no more than 15 edits in the solution code. An edit is considered to be adding, deleting, or changing one character (i.e., the <a href="/material/p1791">Levenshnein distance</a> is actually considered). Your need to find the error, fix it, and get OK on the problem. To give you some margin, you are allowed to make up to 23 edits.</p>

        <p>In the "Find a bug" interface, you are immediately given a text editor in which the solution code is open. I strongly recommend looking for errors directly in this editor, without copying the code anywhere (like your IDE or editor), and accordingly not using a debugger, etc., but only looking at the code with your eyes. But in the most difficult cases, you can copy the code and understand it more thoroughly.</p>

        <p>The solutions in the "Find a bug" section are available in different programming languages. Don't be afraid to look for bugs even in languages you don't know. I try not to allow those solutions in which the error is caused by language problems to search for errors, almost always errors have more algorithmic reasons, and, accordingly, you can find them, even if you do not know the features of the language.</p>

        <p>I do not look at the solutions sent through the "find a bug" section with my eyes and do not comment (in particular, it is impossible to get "accepted" for them), and they do not affect your results in the rankings. Of course, if you can't find an error, you can write to me, I will advise you something.</p>

        <p>Each solution, in addition to the problem, is also characterized by an individual number (a combination of four letters or numbers). Use this number to distinguish between solutions for finding errors for the same problem; in particular, if you want to ask me about such a solution, then specify both the name of the problem and the number of the solution (well, or just send a link to the error search page in this particular solution).</p>
        """, {id: "about_find_mistake"})

contacts = () ->
    label("""
        <div class=\"algoprog-contacts\">
        <h2>Contacts</h2>
        <b>Petr Kalinin</b>
        <ul>
        <li>e-mail: petr@kalinin.nnov.ru</li>
        <li><a href=\"https://vk.com/petr.kalinin\">https://vk.com/petr.kalinin</a>*</li>
        <li>+7(910)794-32-07**</li>
        <li>Telegram: <a href="https://t.me/pkalinin">@pkalinin</a></li>
        <li>Telegram channel with important announcements: <a href=\"https://t.me/algoprog_news\">@algoprog_news</a> (mainly in Russian). </li>
        <li>Telegram chat for all algoprog students (mostly in Russian): <a href="https://t.me/+Ff0fS3PMo85iNmZi">Algoprog-chat</a>.
        To join, you should first specify your telegram id in your algoprog profile.</li>
        </ul>
        <p>My contact details can be freely distributed for any questions related to the course or
        with olympiad programming in general.</p>
        <p><b>If you have any problems with working in the course, any questions, etc., write to me immediately!</b></p>
        <p>* VK friend policy: I don't mind if you add me as a friend,
        but I will only add those who have been successfully engaged for a long time.</p>
        <p>** Please call by phone only in emergency cases. If your question is not very urgent and can
        wait a few hours, write to me in any way indicated above — in VKontakte, in Telegram or by email.
        </p>
        <hr>""")

telegram_bot = () ->
    page("About your telegram account", """
        <h1>About your telegram account</h1>
        <p>In the profile on the algoprog, you can specify the id of your telegram account. It is necessary to specify the id,
        not the username and not the phone. To find out your id, go to Telegram and
        find the bot <a href='https://t.me/getmyid_bot'>@getmyid_bot</a> (or type @getmyid_bot in the search
        and select a bot from the list with the name 'Get My ID'), click on the launch button
        (or write /start), the bot will send you a message with your id.</p>
        <p>This will allow you to:</p>
        <ul>
        <li>join <a href="https://t.me/+Ff0fS3PMo85iNmZi">the telegram chat for all algoprog students</a> (mostly in Russian),</li>
        <li>receive notifications about counted/ignored solutions, and about comments on solutions, to do this, start a chat with <a href="https://t.me/algoprog_bot ">the algoprog bot @algoprog_bot</a>.
        </li>
        </ul>
        """, {id: 'telegram_bot'})

export default level_about = () ->
    return level("about", "About the course", [
        module20927_1(),
        module20927_3(),
        label(
            "<h3>At first</h3></div>"),
        module20927_7(),
        module20927_9(),
        label(
            "<h3>How to study here</h3>"),
        work_with_site(),
        module20927_13(),
        module20927_15(),
        telegram_bot(),
        label(
            "<h3>About payment</h3>"),
        pay(),
        label(
            "<div><a href=\"/payment\" onclick=\"window.goto('/payment')();return false;\">Pay for classes</a></div>"),
        label(
            "<h3>And a bit more...</h3>"),
        module20927_23(),
        module20927_25(),
        module20927_29(),
        achieves(),
        tshirts(),
        about_find_mistake(),
        module20927_35(),
        module20927_37(),
        label(
            "<div style=\"height:1ex;\"></div>\n\n<div><b>\"Internship\" at the algoprog</b></div>"),
        module20927_39(),
        contacts(),
    ])
