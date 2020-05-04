import contest from './lib/contest'
import link from './lib/link'
import level from './lib/level'
import main from './lib/main'
import news from './lib/news'
import newsItem from './lib/newsItem'
import topic from './lib/topic'
import problem from './lib/problem'


export default root = () -> 
    allNews = news([
        newsItem("Новость 1", "Текст новости 1"),
        newsItem("Новость 2", "Текст новости 2")
    ])
    arithm = topic("Арифметические операции",
            "Задачи на арифметические операции",
            [link("http://notes.algoprog.ru/python_basics/0_quick_start.html", "Теория: начало работы в питоне"), 
                problem("2938"), 
                problem("2939")])
    ifs = topic("Условный оператор (if)", "Задачи на условный оператор", [
        link("http://notes.algoprog.ru/python_basics/1_if.html", "Теория по условному оператору"), 
        problem("292"), 
        problem("293")])

    level1A = level("1А", [arithm, ifs])
    level1B = level("1Б", [arithm])
    level2A = level("2А", [arithm])

    level1 = level("1", [level1A, level1B])
    level2 = level("2", [level2A])

    return main([allNews, level1, level2])