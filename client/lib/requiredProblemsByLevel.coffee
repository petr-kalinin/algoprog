export default requiredProblemsByLevel = (level, problemsNumber) ->
    needProblem = problemsNumber
    if level.endsWith("В") || level.endsWith("C")
        needProblem *= 0.5
    else if level.endsWith("Г") ||  level.endsWith("D")
        needProblem *= 1.0 / 3
    return needProblem
