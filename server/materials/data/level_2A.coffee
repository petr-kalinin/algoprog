import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"


contest_ternary_search = () ->
    return contest("2A: Тернарный поиск и вещественный бинарный поиск", [
		problem({testSystem: "codeforces", contest: "gym/100119", problem: "C", name: "Поляна Дров"}),
		problem({testSystem: "codeforces", contest: "gym/100119", problem: "D", name: "Корень кубического уравнения"}),
		problem({testSystem: "codeforces", contest: "gym/100119", problem: "E", name: "Поезда"}),
        problem({testSystem: "codeforces", contest: "1288", problem: "A"}),
        problem({testSystem: "codeforces", contest: "289", problem: "B"}),
        problem({testSystem: "codeforces", contest: "1059", problem: "D"}),
        problem({testSystem: "codeforces", contest: "250", problem: "D"}),
        problem({testSystem: "codeforces", contest: "578", problem: "C"}),
        problem({testSystem: "codeforces", contest: "106", problem: "E"}),
        problem({testSystem: "codeforces", contest: "1413", problem: "E"}),
    ])

contest_hard = () ->
    return contest("2A: Тернарный поиск и вещественный бинарный поиск - посложнее задачи", [
		problem({testSystem: "codeforces", contest: "1374", problem: "E2"}),
        problem({testSystem: "codeforces", contest: "1387", problem: "А"}),
    ])
	
export default level_2A = () ->
    return level("2A", [
        label("Вещественный бинарный поиск (ЛКШ B' июль 2013, Петр Калинин): <a href = 'https://sis.khashaev.ru/2013/august/c-prime/lK2k26ATt38/'>https://sis.khashaev.ru/2013/august/c-prime/lK2k26ATt38/</a>"),
        label("Тернарный поиск (ЛКШ B' июль 2013, Петр Калинин): <a href = 'https://sis.khashaev.ru/2013/july/b-prime/t8O8TB6m_d8/'>https://sis.khashaev.ru/2013/july/b-prime/t8O8TB6m_d8/</a>"),
		label("Тернарный поиск (e-maxx): <a href = 'https://e-maxx.ru/algo/ternary_search'>https://e-maxx.ru/algo/ternary_search</a>"),
        contest_ternary_search(),
		contest_hard(),
    ])
