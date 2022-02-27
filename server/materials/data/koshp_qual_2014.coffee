import contest from "../lib/contest"
import problem from "../lib/problem"

export default c = contest("koshp.qual.2014", "Интернет-отбор на ВКОШП, 2014", "acm", [
            problem({testSystem: "ejudge", contest: "2005", problem: "1", letter: "A", id: "cgym100529pA", name: "ABCD-код"}),
            problem({testSystem: "ejudge", contest: "2005", problem: "2", letter: "B", id: "cgym100529pB", name: "Шахматы"}),
            problem({testSystem: "ejudge", contest: "2005", problem: "3", letter: "C", id: "cgym100529pC", name: "Завоевание"})
            problem({testSystem: "ejudge", contest: "2005", problem: "4", letter: "D", id: "cgym100529pD", name: "Дюны"})
            problem({testSystem: "ejudge", contest: "2005", problem: "5", letter: "E", id: "cgym100529pE", name: "Игра"})
            problem({testSystem: "ejudge", contest: "2005", problem: "6", letter: "F", id: "cgym100529pF", name: "НОД и НОК"})
            problem({testSystem: "ejudge", contest: "2005", problem: "7", letter: "G", id: "cgym100529pG", name: "Мерлин"})
            problem({testSystem: "ejudge", contest: "2005", problem: "8", letter: "H", id: "cgym100529pH", name: "Регистрация на олимпиаду"})
            problem({testSystem: "ejudge", contest: "2005", problem: "9", letter: "I", id: "cgym100529pI", name: "Безопасный путь"})
            problem({testSystem: "ejudge", contest: "2005", problem: "10", letter: "J", id: "cgym100529pJ", name: "Преобразование последовательности"})
            problem({testSystem: "ejudge", contest: "2005", problem: "11", letter: "K", id: "cgym100529pK", name: "Крестики-нолики"})
    ], 300, 240, true)
