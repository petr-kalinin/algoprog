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
	
export default level_1D = () ->
    return level("1E", [
        label("Арифметические алгоритмы (ЛКШ С' август 2013, Владимир Гуровиц). Смотреть все 6 видео в данной теме: <a href='https://sis.khashaev.ru/2013/august/c-prime/lK2k26ATt38/'>https://sis.khashaev.ru/2013/august/c-prime/lK2k26ATt38/</a>"),
        label("Бинарное возведение в степень (e-maxx): <a href='http://e-maxx.ru/algo/binary_pow'>http://e-maxx.ru/algo/binary_pow</a>"),
        label("Алгоритм Евклида нахождение НОД (e-maxx): <a href='http://e-maxx.ru/algo/euclid_algorithm'>http://e-maxx.ru/algo/euclid_algorithm</a>"),
        label("Решето Эратосфена (e-maxx): <a href='http://e-maxx.ru/algo/eratosthenes_sieve'>http://e-maxx.ru/algo/eratosthenes_sieve</a>"),
        contest_num_theory(),
    ])
