import contest from "../../lib/contest"
import label from "../../lib/label"
import link from "../../lib/link"
import page from "../../lib/page"
import problem from "../../lib/problem"
import topic from "../../lib/topic"

export default flows = () ->
    return {
        topic: topic("Простые потоки", "Задачи на простые потоки", [
            label("<p>См. теорию на вики ИТМО: <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=%D0%9E%D0%BF%D1%80%D0%B5%D0%B4%D0%B5%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5_%D1%81%D0%B5%D1%82%D0%B8,_%D0%BF%D0%BE%D1%82%D0%BE%D0%BA%D0%B0\">1</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%A4%D0%BE%D1%80%D0%B4%D0%B0-%D0%A4%D0%B0%D0%BB%D0%BA%D0%B5%D1%80%D1%81%D0%BE%D0%BD%D0%B0,_%D1%80%D0%B5%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F_%D1%81_%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E_%D0%BF%D0%BE%D0%B8%D1%81%D0%BA%D0%B0_%D0%B2_%D0%B3%D0%BB%D1%83%D0%B1%D0%B8%D0%BD%D1%83\">2</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%AD%D0%B4%D0%BC%D0%BE%D0%BD%D0%B4%D1%81%D0%B0-%D0%9A%D0%B0%D1%80%D0%BF%D0%B0\">3</a>, <a href=\"https://neerc.ifmo.ru/wiki/index.php?title=%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B7,_%D0%BB%D0%B5%D0%BC%D0%BC%D0%B0_%D0%BE_%D0%BF%D0%BE%D1%82%D0%BE%D0%BA%D0%B5_%D1%87%D0%B5%D1%80%D0%B5%D0%B7_%D1%80%D0%B0%D0%B7%D1%80%D0%B5%D0%B7\">4</a>.\n</p>\n<p>Если в вики ИТМО слишком теоретизированно, посмотрите где-нибудь еще. Продвинутые алгоритмы потока (проталкивание предпотока, Диница) пока не нужны.</p>"),
            problem(2783),
            problem(1574),
            problem(111772),
            problem(2917),
            problem(2785),
        ], "flows"),
        advancedProblems: [
            problem(2784),
            problem(2512),
            problem(3300),
            problem(395),
            problem(2821),
            problem(1650),
            problem(186),
            problem({testSystem: "codeforces", contest: "1082", problem: "G"}),
        ]
    }