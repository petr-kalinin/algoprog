import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"


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
	
export default level_1E = () ->
    return level("1E", [
        label("Арифметические алгоритмы (ЛКШ С' август 2013, Владимир Гуровиц). Смотреть все 6 видео в данной теме: https://sis.khashaev.ru/2013/august/c-prime/lK2k26ATt38/"),
        label("Бинарное возведение в степень (e-maxx): http://e-maxx.ru/algo/binary_pow"),
        label("Алгоритм Евклида нахождение НОД (e-maxx): http://e-maxx.ru/algo/euclid_algorithm"),
        label("Решето Эратосфена (e-maxx): http://e-maxx.ru/algo/eratosthenes_sieve"),
        contest_num_theory(),
		
		label("Жадные алгоритмы (Алгоритмика от Tinkoff Generation: <a href='https://ru.algorithmica.org/cs/combinatorial-optimization/greedy/'>https://ru.algorithmica.org/cs/combinatorial-optimization/greedy/</a>"),
		label("Жадные алгоритмы (Algoprog, Петр Калинин: <a href='https://algoprog.ru/material/greedy_simple.1'>https://algoprog.ru/material/greedy_simple.1</a>"),
		label("При решении задач обязательно нужно применить 'жадный' подход"),
		contest_greedy(),
    ])
