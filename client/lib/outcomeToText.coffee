import globalStyles from '../components/global.css'
import {LangRawAny, LangRaw} from '../lang/lang'

MESSAGES =
    DR:
        ru: "Черновик"
        en: "Draft"
    AC:
        ru: "Зачтено"
        en: "Accepted"
    IG:
        ru: "Проигнорировано"
        en: "Ignored"
    OK:
        ru: "OK"
        en: "OK"
    CE:
        ru: "Ошибка компиляции"
        en: "Compilation error"
    DQ:
        ru: "Дисквалифицировано"
        en: "Disqualified"
    CT:
        ru: "Тестируется..."
        en: "Testing..."
    PS:
        ru: "Отправка..."
        en: "Submitting..."
    DP:
        ru: "Вы уже отправляли этот код"
        en: "You have already submitted this code"
    PW:
        ru: "Проверьте пароль от тестирующей системы в профиле на алгопроге"
        en: "Chech the testing system password in algoprog profile"
    FL:
        ru: "Ошибка проверки, переотправьте"
        en: "Internal error, please re-submit"
    CM:
        ru: "Ошибка проверки, свяжитесь со мной"
        en: "Internal error, please contact me"
    WA:
        ru: "Неправильный ответ"
        en: "Wrong answer"
    RE:
        ru: "Ошибка во время выполнения"
        en: "Run-time error"
    TL:
        ru: "Превышен предел времени"
        en: "Time limit exceeded"
    PE:
        ru: "Неправильный формат вывода"
        en: "Presentation error"
    WS:
        ru: "Неполное решение"
        en: "Partial solution"
    ML:
        ru: "Превышение предела памяти"
        en: "Memory limit exceeded"
    SE:
        ru: "Security error"
        en: "Security error"
    SK:
        ru: "Пропущено"
        en: "Skipped"
    

CLASSES = 
    AC: "success"
    IG: "info"
    DQ: globalStyles.dq_text
    OK: "warning"


export default outcomeToText = (outcome, lang, check) ->
    [outcome, points] = outcome.split(":")
    cl = CLASSES[outcome]
    message = LangRawAny(MESSAGES[outcome], lang, outcome, false)
    if message and points
        message += " " + LangRaw("outcome_points", lang)(points)
    if not (message?) and not check
        message = outcome
    return [cl, message]

