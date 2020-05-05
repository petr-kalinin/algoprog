import contest from './lib/contest'
import epigraph from './lib/epigraph'
import label from './lib/label'
import labelLink from './lib/labelLink'
import level from './lib/level'
import link from './lib/link'
import main from './lib/main'
import news from './lib/news'
import newsItem from './lib/newsItem'
import page from './lib/page'
import table from './lib/table'
import topic from './lib/topic'
import problem from './lib/problem'
import simpleLevel from './lib/simpleLevel'


getTableTitle = (table) ->
    if table == "reg"
        return "Сводная таблица по региональным олимпиадам"
    else if table == "roi"
        return "Сводная таблица по всероссийским олимпиадам"
    else if table == "main"
        return "Сводная таблица по всем уровням"
    else if table == "byWeek"
        return "Сводная таблица по неделям"
    tables = table.split(",")
    if tables.length == 1
        return "Сводная таблица по уровню " + table
    else
        return "Сводная таблица по уровням " + tables.join(", ")

getTreeTitle = (table) ->
    if table == "reg"
        return "Региональные олимпиады"
    else if table == "roi"
        return "Всероссийские олимпиады"
    else if table == "main"
        return "Все уровни"
    else if table == "byWeek"
        return "По неделям"
    tables = table.split(",")
    if tables.length == 1
        return "Уровень " + table
    else
        return "Уровни " + tables.join(", ")

tables = () ->
    groups =
        lic40: "Лицей 40",
        lic87: "Лицей 87",
        zaoch: "Нижегородские школьники",
        vega: "Вега",
        notnnov: "Остальные школьники"
        stud: "Студенты и старше"
    allTables = ["1А,1Б", "1В,1Г", "2", "3", "4", "5", "6", "7", "8", "9", "main", "reg", "roi", "byWeek"]

    materials = []
    for group, groupName of groups
        thisMaterials = []
        for t in allTables
            thisMaterials.push(table(group, t, getTableTitle(t), getTreeTitle(t)))

        material = simpleLevel("tables:#{group}", groupName, thisMaterials)
        materials.push(material)

    return simpleLevel("tables", "Сводные таблицы", materials)

level0 = () ->
    epi = epigraph("Эпиграф", "Текст эпиграфа")
    header = label("<h4>Общая информация</h4>")
    faq = page("Общие вопросы", "Раз два три")

    _level0 = level("about", "О курсе", [epi, header, faq])

    return _level0


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

    return main([level0(), allNews, comments, level1, level2, reg, tables()])()