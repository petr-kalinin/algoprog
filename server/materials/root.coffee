import link from './lib/link'
import level from './lib/level'
import main from './lib/main'
import topic from './lib/topic'
import problem from './lib/problem'


export default root = () -> 
    arithm = topic("Арифметические операции", [
            link("http://notes.algoprog.ru/python_basics/0_quick_start.html", "Начало работы в питоне"), 
            problem("2938"), 
            problem("2939")])
    ifs = topic("Условный оператор (if)", [
        link("http://notes.algoprog.ru/python_basics/1_if.html", "Теория по условному оператору"), 
        problem("292"), 
        problem("293")])

    level1A = level("1А", [arithm, ifs])
    level1B = level("1Б", [arithm])
    level2A = level("2А", [arithm])

    level1 = level("1", [level1A, level1B])
    level2 = level("2", [level2A])

    return main([level1, level2])