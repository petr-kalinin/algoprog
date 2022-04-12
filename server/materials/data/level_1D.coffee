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
        problem({testSystem: "codeforces", contest: "977", problem: "Е", name: "Компоненты-циклы"}),
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


export default level_1D = () ->
    return level("1D", [
        label("Теоретический материал Базовая теория графов:&nbsp;<a href=\"https://youtu.be/FQJCuxKpGBg\" target=\"_blank\">https://youtu.be/FQJCuxKpGBg</a>"),
        contest_graph_basics(),
        label("Теоретический материал DFS (материал Петра Калинина), изучать с 8.1 по 8.3 включительно:&nbsp;<a href=\"https://notes.algoprog.ru/dfs/index.html\" target=\"_blank\">https://notes.algoprog.ru/dfs/index.html</a>"),
        contest_dfs1(),
        contest_dfs2(),
    ])
