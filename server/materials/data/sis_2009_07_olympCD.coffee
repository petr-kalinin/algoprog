import contest from "../lib/contest"
import problem from "../lib/problem"

export default contest("sis.2009.07.olympCD", "Двенадцатая международная олимпиада школьников ЛКШ среди параллелей C и D (2009.Июль)", "acm", [
            problem({testSystem: "ejudge", contest: "2006", problem: "1"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "2"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "3"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "4"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "5"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "6"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "7"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "8"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "9"}),
            problem({testSystem: "ejudge", contest: "2006", problem: "10"}),
    ], 180, 144, true)
