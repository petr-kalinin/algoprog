import contest from "../lib/contest"
import problem from "../lib/problem"

export default c = contest("koshp.qual.2014", "Интернет-отбор на ВКОШП, 2014", "acm", [
            problem({testSystem: "ejudge", contest: "2005", problem: "1", id:"cgym100529pA", name: "ABCD-код"}),
            problem({testSystem: "ejudge", contest: "2005", problem: "2", id:"cgym100529pB", name: "Шахматы"}),
            problem({testSystem: "ejudge", contest: "2005", problem: "3", id:"cgym100529pC", name: "Завоевание"})
            problem({testSystem: "ejudge", contest: "2005", problem: "4", id:"cgym100529pD", name: "Дюны"})
            problem({testSystem: "ejudge", contest: "2005", problem: "5", id:"cgym100529pE", name: "Игра"})
            problem({testSystem: "ejudge", contest: "2005", problem: "6", id:"cgym100529pF", name: "НОД и НОК"})
            problem({testSystem: "ejudge", contest: "2005", problem: "7", id:"cgym100529pG", name: "Мерлин"})
            problem({testSystem: "ejudge", contest: "2005", problem: "8", id:"cgym100529pH", name: "Регистрация на олимпиаду"})
            problem({testSystem: "ejudge", contest: "2005", problem: "9", id:"cgym100529pI", name: "Безопасный путь"})
            problem({testSystem: "ejudge", contest: "2005", problem: "10", id:"cgym100529pJ", name: "Преобразование последовательности"})
            problem({testSystem: "ejudge", contest: "2005", problem: "11", id:"cgym100529pK", name: "Крестики-нолики"})
    ], 300, 240)
