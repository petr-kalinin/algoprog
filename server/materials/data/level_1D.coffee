import contest from "../lib/contest"
import label from "../lib/label"
import level from "../lib/level"
import problem from "../lib/problem"


contest_graph_basics = () ->
    return contest("1D: Базовая теория графов", [
        problem(460),
        problem(461),
        problem(462),
        problem(463),
        problem(464),
        problem(466),
        problem(111539),
        problem(470),
        problem(471),
        problem(476),
        problem(174),
        problem(175),
        problem(176),
    ])
	

contest_dfs1 = () ->
    return contest("1D: DFS 1", [
        problem(164),
        problem(111540),
        problem(111541),
        problem(165),
        problem(652),
        problem(166),
        problem(114091),
    ])
	
	
contest_dfs2 = () ->
    return contest("1D: DFS 2", [
        problem({testSystem: "codeforces", contest: "522", problem: "A", name: "Репосты"}),
        problem({testSystem: "codeforces", contest: "277", problem: "A", name: "Изучение языков"}),
        problem({testSystem: "codeforces", contest: "977", problem: "E", name: "Компоненты-циклы"}),
        problem({testSystem: "codeforces", contest: "580", problem: "C", name: "Кефа и парк"}),
        problem({testSystem: "codeforces", contest: "687", problem: "A", name: "NP-трудная задача"}),
        problem({testSystem: "codeforces", contest: "771", problem: "A", name: "Мишка и условие дружбы"}),
        problem({testSystem: "codeforces", contest: "862", problem: "B", name: "Махмуд, Ехаб и двудольность"}),
        problem({testSystem: "codeforces", contest: "659", problem: "E", name: "Новая реформа"}),
        problem({testSystem: "codeforces", contest: "500", problem: "B", name: "Новогодняя перестановка"}),
        problem({testSystem: "codeforces", contest: "1336", problem: "A", name: "Linova и королевство"}),
        problem({testSystem: "codeforces", contest: "1144", problem: "F", name: "Граф без длинных ориентированных путей"}),
        problem({testSystem: "codeforces", contest: "1209", problem: "D", name: "Корова и вечеринка"}),
    ])
	
contest_bfs0 = () ->
    return contest("1D: BFS 1", [
        problem(160),
        problem(161),
        problem(162),
        problem(1472),
        problem(2001),
        problem(2002),
        problem(2003),
    ])

contest_bfs1 = () ->
    return contest("1D: BFS 2", [
        problem({testSystem: "codeforces", contest: "727", problem: "A"}),
        problem({testSystem: "codeforces", contest: "520", problem: "B"}),
        problem({testSystem: "codeforces", contest: "602", problem: "C"}),
        problem({testSystem: "codeforces", contest: "1105", problem: "D"}),
        problem({testSystem: "codeforces", contest: "598", problem: "D"}),
        problem({testSystem: "codeforces", contest: "35", problem: "C"}),
        problem({testSystem: "codeforces", contest: "370", problem: "A"}),
        problem({testSystem: "codeforces", contest: "329", problem: "B"}),
        problem({testSystem: "codeforces", contest: "242", problem: "C"}),
        problem({testSystem: "codeforces", contest: "198", problem: "B"}),
        problem({testSystem: "codeforces", contest: "877", problem: "D"}),
        problem({testSystem: "codeforces", contest: "59", problem: "E"}),
        problem({testSystem: "codeforces", contest: "796", problem: "D"}),
        problem({testSystem: "codeforces", contest: "821", problem: "D"}),
    ])

contest_B_1 = () ->
	return contest("1D: Ladder B Contest 1", [
		problem({testSystem: "codeforces", contest: "266", problem: "B", name: "Очередь в школе"}),
		problem({testSystem: "codeforces", contest: "339", problem: "B", name: "Ксюша и кольцевая дорога"}),
		problem({testSystem: "codeforces", contest: "467", problem: "B", name: "Федя и новая игра"}),
		problem({testSystem: "codeforces", contest: "478", problem: "B", name: "Случайные команды"}),
		problem({testSystem: "codeforces", contest: "492", problem: "B", name: "Ваня и фонари"}),
		problem({testSystem: "codeforces", contest: "451", problem: "B", name: "Сортируем массив"}),
		problem({testSystem: "codeforces", contest: "499", problem: "B", name: "Лекция"}),
		problem({testSystem: "codeforces", contest: "230", problem: "B", name: "Т-простые числа"}),
		problem({testSystem: "codeforces", contest: "508", problem: "B", name: "Антон и та самая валюта"}),
		problem({testSystem: "codeforces", contest: "447", problem: "B", name: "DZY любит строки"}),
		problem({testSystem: "codeforces", contest: "507", problem: "B", name: "Amr и булавки"}),
		problem({testSystem: "codeforces", contest: "454", problem: "B", name: "Маленькая пони и сортировка сдвигами"}),
		problem({testSystem: "codeforces", contest: "450", problem: "B", name: "Jzzhu и последовательности"}),
		problem({testSystem: "codeforces", contest: "265", problem: "B", name: "Деревья у дороги (упрощ. редакция)"}),
		problem({testSystem: "codeforces", contest: "285", problem: "B", name: "Найди шарик"}),
		problem({testSystem: "codeforces", contest: "448", problem: "B", name: "Про суффиксные структуры"}),
		problem({testSystem: "codeforces", contest: "259", problem: "B", name: "Маленький Слоник и магический квадрат"}),
		problem({testSystem: "codeforces", contest: "486", problem: "B", name: "OR в матрице"}),
		problem({testSystem: "codeforces", contest: "432", problem: "B", name: "Футбольная форма"}),
		problem({testSystem: "codeforces", contest: "276", problem: "B", name: "Девочка и игра"}),
	]) 

contest_B_2 = () ->
	return contest("1D: Ladder B Contest 2", [
		problem({testSystem: "codeforces", contest: "362", problem: "B"}),
		problem({testSystem: "codeforces", contest: "279", problem: "B"}),
		problem({testSystem: "codeforces", contest: "469", problem: "B"}),
		problem({testSystem: "codeforces", contest: "509", problem: "B"}),
		problem({testSystem: "codeforces", contest: "493", problem: "B"}),	
		problem({testSystem: "codeforces", contest: "387", problem: "B"}),	
		problem({testSystem: "codeforces", contest: "365", problem: "B"}),
		problem({testSystem: "codeforces", contest: "157", problem: "B"}),
		problem({testSystem: "codeforces", contest: "34", problem: "B"}),
		problem({testSystem: "codeforces", contest: "330", problem: "B"}),
		problem({testSystem: "codeforces", contest: "116", problem: "B"}),
		problem({testSystem: "codeforces", contest: "4", problem: "B"}),
		problem({testSystem: "codeforces", contest: "282", problem: "B"}),
		problem({testSystem: "codeforces", contest: "122", problem: "B"}),
		problem({testSystem: "codeforces", contest: "155", problem: "B"}),
		problem({testSystem: "codeforces", contest: "352", problem: "B"}),
		problem({testSystem: "codeforces", contest: "133", problem: "B"}),
		problem({testSystem: "codeforces", contest: "289", problem: "B"}),
		problem({testSystem: "codeforces", contest: "366", problem: "B"}),
		problem({testSystem: "codeforces", contest: "58", problem: "B"}),
	])
	
contest_shortcut_1 = () ->
	return contest("1D: Дейкстра, Флойд, Форд-Беллман - базовые задачи", [
		problem(5),
		problem(6),
		problem(3494),
		problem(1745),
		problem(1087),
		problem(171),
		problem(173),
		problem(178),
		problem(180),
		problem(179),
		problem(95),
		problem(96),
		problem(97),
		problem(1329),
		problem(1332),
		problem(1334),
		problem(1335),
		problem(2598),
		
	])
	
contest_shortcut_2 = () ->
	return contest("1D: Кратчайшие расстояния - другие задачи", [
		problem({testSystem: "codeforces", contest: "601", problem: "A"}),
		problem({testSystem: "codeforces", contest: "543", problem: "B"}),
		problem({testSystem: "codeforces", contest: "295", problem: "B"}),
		problem({testSystem: "codeforces", contest: "707", problem: "B"}),	
		problem({testSystem: "codeforces", contest: "24", problem: "A"}),	
		problem({testSystem: "codeforces", contest: "543", problem: "B"}),
		problem({testSystem: "codeforces", contest: "35", problem: "C"}),
		problem({testSystem: "codeforces", contest: "25", problem: "C"}),
		problem({testSystem: "codeforces", contest: "33", problem: "B"}),
		problem({testSystem: "codeforces", contest: "977", problem: "E"}),
		problem({testSystem: "codeforces", contest: "771", problem: "A"}),
		problem({testSystem: "codeforces", contest: "1106", problem: "D"}),
		problem({testSystem: "codeforces", contest: "1321", problem: "D"}),
		problem({testSystem: "codeforces", contest: "1681", problem: "D"}),
	])
	
export default level_1D = () ->
    return level("1D", [
        label("Теоретический материал Базовая теория графов:&nbsp;<a href=\"https://youtu.be/FQJCuxKpGBg\" target=\"_blank\">https://youtu.be/FQJCuxKpGBg</a>"),
        contest_graph_basics(),
        label("Теоретический материал DFS (материал Петра Калинина), изучать с 8.1 по 8.3 включительно:&nbsp;<a href=\"https://notes.algoprog.ru/dfs/index.html\" target=\"_blank\">https://notes.algoprog.ru/dfs/index.html</a>"),
        contest_dfs1(),
        contest_dfs2(),
        label("Ladder B из codeforces - 100 задач"),
        contest_B_1(),
        contest_B_2(),
        label("Теоретический материал BFS (лекция Владимира Гуровца, ЛКШ 2013г): <a href='https://sis.khashaev.ru/2013/august/c-prime/YKxe2ZFVkHQ/'>https://sis.khashaev.ru/2013/august/c-prime/YKxe2ZFVkHQ/</a>"),
        contest_bfs0(),
        contest_bfs1(),
        label("<a href='https://sis.khashaev.ru/2008/august/b-prime/P0tGgwUjvBA/'>Теоретический материал алгоритм Дейкстры (лекция Сергея Копелиовича, ЛКШ 2008г)</a>"),
        label("<a href='https://sis.khashaev.ru/2008/august/b-prime/P0tGgwUjvBA/'>Теоретический материал алгоритм Дейкстры O(MlogN) (лекция Руслана Сайфутдинова, ЛКШ 2013г)</a>"),
        label("<a href='https://e-maxx.ru/algo/dijkstra_sparse'>Теоретический материал алгоритм Дейкстры O(MlogN) (e-maxx)</a>"),
        label("<a href='https://sis.khashaev.ru/2013/july/b-prime/1fCe1I5ZV64/'>Теоретический материал алгоритм Флойда, Форда-Беллмана (лекция Руслана Сайфутдинова, ЛКШ 2013г)</a>"),
        contest_shortcut_1(),
        contest_shortcut_2(),
		
    ])
