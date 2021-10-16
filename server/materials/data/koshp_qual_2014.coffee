import contest from "../lib/contest"
import problem from "../lib/problem"

export default c = contest("koshp.qual.2014", "Интернет-отбор на ВКОШП, 2014", "acm", [
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "A", name: "ABCD-код"}),
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "B", name: "Шахматы"}),
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "C", name: "Завоевание"})
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "D", name: "Дюны"})
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "E", name: "Игра"})
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "F", name: "НОД и НОК"})
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "G", name: "Мерлин"})
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "H", name: "Регистрация на олимпиаду"})
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "I", name: "Безопасный путь"})
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "J", name: "Преобразование последовательности"})
            problem({testSystem: "codeforces", contest: "gym/100529", problem: "K", name: "Крестики-нолики"})
    ], 300, 240)
