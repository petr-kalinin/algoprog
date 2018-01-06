export default requiredProblemsByLevel = (level, problemsNumber) ->
    needProblem = problemsNumber
    if level.endsWith("В")
        needProblem *= 0.5
    else if level.endsWith("Г")
        needProblem *= 1.0 / 3
    return needProblem
