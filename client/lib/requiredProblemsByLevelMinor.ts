export default function requiredProblemsByLevelMinor(levelMinor: number, problemsNumber: number) {
    let needProblem = problemsNumber
    if (levelMinor == 3)
        needProblem *= 0.5
    else if (levelMinor == 4)
        needProblem *= 1.0 / 3
    return needProblem
}