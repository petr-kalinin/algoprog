import contest from './lib/contest'
import labelLink from './lib/labelLink'
import level from './lib/level'
import link from './lib/link'
import main from './lib/main'
import news from './lib/news'
import newsItem from './lib/newsItem'
import table from './lib/table'
import topic from './lib/topic'
import problem from './lib/problem'
import simpleLevel from './lib/simpleLevel'

tables = () ->
    groups =
        lic40: "Лицей 40",
        lic87: "Лицей 87",
        zaoch: "Нижегородские школьники",
        vega: "Вега",
        notnnov: "Остальные школьники"
        stud: "Студенты и старше"
    tables = ["1А,1Б", "1В,1Г", "2", "3", "4", "5", "6", "7", "8", "9", "main", "reg", "roi", "byWeek"]

    materials = []
    for group, groupName of groups
        thisMaterials = []
        for t in tables
            thisMaterials.push(table(group, t))

        material = simpleLevel("tables:#{group}", groupName, thisMaterials)
        materials.push(material)

    return simpleLevel("tables", "Сводные таблицы", materials)

export default root = () -> 
    allNews = news([
        newsItem("Новость 1", "Текст новости 1"),
        newsItem("Новость 2", "Текст новости 2")
    ])
    comments = link("comments", "/comments", "Комментарии")
    arithm = topic("Арифметические операции",
            "Задачи на арифметические операции",
            [labelLink("http://notes.algoprog.ru/python_basics/0_quick_start.html", "Теория: начало работы в питоне"), 
                problem("2938"), 
                problem("2939")])
    ifs = topic("Условный оператор (if)", "Задачи на условный оператор", [
        labelLink("http://notes.algoprog.ru/python_basics/1_if.html", "Теория по условному оператору"), 
        problem("292"), 
        problem("293")])

    contest1 = contest("Доп. задачи 1", [problem("2946"), problem("2945")])
    contest2 = contest("Доп. задачи 2", [problem("2947"), problem("2948")])

    level1A = level("1А", [arithm, ifs])
    level1B = level("1Б", [arithm])
    level1C = level("1В", [contest1, contest2])

    level2A = level("2А", [arithm])

    level1 = level("1", [level1A, level1B, level1C])
    level2 = level("2", [level2A])

    reg2009_1 = contest("2009, 1 тур", [problem("2949"), problem("2950")])
    reg2009 = simpleLevel("reg2009", "2009", [reg2009_1])
    reg = simpleLevel("reg", "Региональные олимпиады", [reg2009])

    return main([allNews, comments, level1, level2, reg, tables()])()