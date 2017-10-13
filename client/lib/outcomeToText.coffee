export default outcomeToText = (outcome) ->
    cl = undefined
    message = outcome
    switch outcome
        when "Частичное решение"
            message = "Неполное решение"
        when "AC"
            cl = "success"
            message = "Зачтено"
        when "IG"
            cl = "info"
            message = "Проигнорировано"
        when "OK"
            cl = "warning"
        when "CE"
            message = "Ошибка компиляции"
        when "DQ"
            message = "Дисквалифицировано"
    return [cl, message]
