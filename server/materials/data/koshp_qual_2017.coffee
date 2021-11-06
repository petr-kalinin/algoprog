import contest from "../lib/contest"
import problem from "../lib/problem"

export default c = contest("koshp.qual.2017", "Интернет-отбор на ВКОШП, 2017", "acm", [
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "A", name: "Закономерности"}),
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "B", name: "Интересная экскурсия"}),
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "C", name: "Прыжки с поворотом"})
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "D", name: "Подсчеты в строю"})
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "E", name: "Разные цифры"})
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "F", name: "Рисование"})
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "G", name: "Последняя битва"})
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "H", name: "Расписание"})
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "I", name: "Пицца"})
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "J", name: "Ретвинтим twinter"})
            problem({testSystem: "codeforces", contest: "gym/101609", problem: "K", name: "Дробление"})
    ], 300, 240)
