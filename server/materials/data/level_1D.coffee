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


export default level_1D = () ->
    return level("1D", [
        label("Теоретический материал Базовая теория графов:&nbsp;<a href=\"https://youtu.be/FQJCuxKpGBg\" target=\"_blank\">https://youtu.be/FQJCuxKpGBg</a>"),
        contest_graph_basics(),
        label("Теоретический материал DFS (материал Петра Калинина), изучать с 8.1 по 8.3 включительно:&nbsp;<a href=\"https://notes.algoprog.ru/dfs/index.html\" target=\"_blank\">https://notes.algoprog.ru/dfs/index.html</a>"),
        contest_dfs1(),
    		contest_dfs2(),
		    label("Ladder B из codeforces - 100 задач"),
		    contest_B_1(),
    ])
