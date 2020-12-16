import globalStyles from '../components/global.css'

export default outcomeToText = (outcome) ->
    cl = undefined
    message = outcome
    switch outcome
        when "Частичное решение"
            message = "Неполное решение"
        when "DR"
            message = "Черновик"
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
            cl = globalStyles.dq_text
            message = "Дисквалифицировано"
        when "CT"
            message = "Тестируется..."
        when "PS"
            message = "Отправка..."
        when "DP"
            message = "Вы уже отправляли этот код"
        when "PW"
            message = "Проверьте пароль от тестирующей системы в профиле на алгопроге"
    return [cl, message]
