React = require('react')

import { Link } from 'react-router-dom'

import withLang from '../lib/withLang'

_LANG = 
    news:
        "ru": "Новости"
        "en": "News"
    recent_comments:
        "ru": "Последние комментарии"
        "en": "Recent comments"
    all_comments:
        "ru": "Все комментарии"
        "en": "All comments"
    material_suffix:
        "ru": ""
        "en": "!en"
    Petr_Kalinin:
        "ru": "Петр Калинин",
        "en": "Petr Kalinin"
    about_license:
        "ru": "О лицензии на материалы сайта",
        "en": "About the license for the site materials"
    blog:
        "ru": "Блог"
        "en": "Blog (in Russian)"
    paid_till:
        "ru": "Занятия оплачены до"
        "en": "Paid till"
    was_paid_till:
        "ru": "Занятия были оплачены до "
        "en": "Was paid till"
    extend_payment:
        "ru": "Продлить"
        "en": "Extend"
    pay:
        "ru": "Оплатить занятия"
        "en": "Pay for the course"
    account_not_activated:
        "ru": "Учетная запись не активирована"
        "en": "Account was not activated"
    account_not_activated_long:
        "ru": "Ваша учетная запись еще не активирована. Вы можете сдавать задачи, но напишите мне, чтобы я активировал вашу учетную запись. Мои контакты — на страничке "
        "en": "Your account was not activated yet. You can start solving the problems, but please write to me so that I activate your account. My contacts are on the "
    account_not_activated_blocked_long:
        "ru": "Ваша учетная запись еще не активирована. Если вы хотите заниматься, напишите мне, чтобы я активировал вашу учетную запись. Мои контакты — на страничке "
        "en": "Your account was not activated yet. Please write to me so that I activate your account. My contacts are on the "
    about_course_page:
        "ru": "О курсе"
        "en": "About course page"
    unpaid:
        "ru": "Занятия не оплачены"
        "en": "You have not paid for the course"
    course_was_paid_only_until:
        "ru": "Ваши занятия оплачены только до "
        "en": "The course was paid only until "
    unpaid_blocked_long:
        "ru": <p>Оплата просрочена более чем на 3 дня. <b>Ваш аккаунт заблокирован до <Link to="/payment">полной оплаты</Link>.</b></p>
        "en": <p>The payment is due for more than 3 days. <b>Your account is blocked until <Link to="/payment">full payment</Link>.</b></p>
    unpaid_not_blocked_long:
        "ru": <p>Вы можете пока решать задачи, но{" "}<Link to="/payment">продлите оплату</Link> в ближайшее время.</p>
        "en": <p>You can still continue solving, but please{" "}<Link to="/payment">extend the payment</Link> asap.</p>
    if_you_have_paid_contact_me:
        "ru": "Если вы на самом деле оплачивали занятия, или занятия для вас должны быть бесплатными, свяжитесь со мной."
        "en": "If you have in fact paid for the course, please contact me."
    class:
        "ru": "Класс"
        "en": "Grade"
    level:
        "ru": "Уровень"
        "en": "Level"
    rating:
        "ru": "Рейтинг"
        "en": "Rating"
    activity:
        "ru": "Активность"
        "en": "Activity"
    cf_login_unknown:
        "ru": "Логин на codeforces неизвестен. Если вы там зарегистрированы, укажите логин в своём профиле."
        "en": "Codeforces login unknown. If you have a CF account, please specify it in your profile."
    you_have_tshirts:
        "ru": "У вас есть неполученные футболки. Напишите мне, чтобы их получить."
        "en": "You have earned a tshirt. Please write me to know how you can get it."
    not_activated_top_panel:
        ru: "Учетная запись не активирована, напишите мне"
        en: "Account not activated, please write me"
    not_paid_top_panel:
        ru: "Занятия не оплачены"
        en: "Course was not paid for"
    unknown_user:
        ru: "Неизвестный пользователь"
        en: "Unknown user"
    sign_out:
        ru: "Выход"
        en: "Sign out"
    register:
        ru: "Регистрация"
        en: "Sign up"
    sign_in:
        ru: "Вход"
        en: "Sign in"
    cf_rating:
        ru: "Рейтинг на Codeforces"
        en: "Codeforces rating"
    cf_progress:
        ru: "Взвешенный прирост рейтинга за последнее время"
        en: "Recent weighted rating change"
    cf_activity:
        ru: "Взвешенное количество написанных контестов за последнее время"
        en: "Recent weighted number of contests written"
    wrong_login_or_password:
        ru: "Неверный логин или пароль"
        en: "Wrong login or password"
    sign_in_full:
        ru: "Вход в систему"
        en: "Sign in"
    login:
        ru: "Логин"
        en: "Username"
    password:
        ru: "Пароль"
        en: "Password"
    do_sign_in:
        ru: "Войти"
        en: "Sign in!"
    good_submits:
        ru: "Хорошие решения"
        en: "Good submits"
    close:
        ru: "Закрыть"
        en: "Close"
    commentText_AC:
        ru: "Решение зачтено"
        en: "Solution has been accepted"
    commentText_IG:
        ru: "Решение проигнорировано"
        en: "Solution has been ignored"
    commentText_DQ:
        ru: "Решение дисквалифицировано"
        en: "Solution has been disqualified"
    commentText_comment:
        ru: "Решение прокомментировано"
        en: "Solution has been commented"
    go_to_problem:
        ru: "Перейти к задаче"
        en: "Go to problem"
    months_short:
        ru: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
        en: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    dow_short:
        ru: ["пн", "вт", "ср", "чт", "пт", "сб", "вс"]
        en: ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
    domain:
        ru: "algoprog.ru"
        en: "algoprog.org"
    default_title:
        ru: "Алгоритмическое программирование"
        en: "Algorithmic programming"
    edit_profile:
        ru: "Редактировать профиль"
        en: "Edit profile"
    old_password_required:
        ru: "Старый пароль (обязательно)"
        en: "Old password (required)"
    wrong_password:
        ru: "Неправильный пароль"
        en: "Wrong password"
    change_password:
        ru: "Сменить пароль"
        en: "Change password"
    new_password:
        ru: "Новый пароль"
        en: "New password"
    repeat_password:
        ru: "Повторите пароль"
        en: "Repeat password"
    passwords_are_not_equal:
        ru: "Пароли не совпадают"
        en: "Passwords are not equal"
    password_can_not_start_with_space:
        ru: "Пароль не может начинаться с пробела или заканчиваться на него"
        en: "Password can not start with space or end in space"
    profile_data:
        ru: "Данные профиля"
        en: "Profile data"
    new_name:
        ru: "Имя"
        en: "Name"
    codeforces_handle:
        ru: "Хендл (никнейм) на codeforces"
        en: "Codeforces handle"
    class:
        ru: "Класс"
        en: "School year"
    informatics_password:
        ru: "Пароль от informatics"
        en: "Informatics password"
    informatics_password_does_not_match_account:
        ru: (id) -> <div>Пароль не подходит к <a href="https://informatics.mccme.ru/user/view.php?id=#{id}">вашему аккаунту на informatics</a></div>
        en: (id) -> <div>Password does not match <a href="https://informatics.mccme.ru/user/view.php?id=#{id}">your informatics account</a></div>
    codeforces_data_for_submitting_problems:
        ru: "Данные codeforces для отправки решений"
        en: "Codeforces data for submitting problems"
    codeforces_data_for_submitting_problems_intro:
        ru: "Некоторые задачи отправляются на codeforces, а не на информатикс. 
                        Для их отправки нужны логин и пароль от какого-нибудь вашего аккаунта на cf.
                        Вы можете указать данные того же аккаунта, что и выше, или можете зарегистрировать
                        отдельный аккаунт только для отправки решений с алгопрога, если не хотите указывать пароль
                        от вашего основного аккаунта."
        en: "Some tasks are sent to codeforces, not to informatics.
                        To send them, you need to provide a username and password from some of your cf account.
                        You can specify the data of the same account as above, or you can register
                        a separate account only for sending solutions from the algoprog, if you do not want to specify a password
                        from your main account"
    codeforces_data_for_submitting_problems_handle:
        ru: "Хендл (никнейм) на codeforces для отправки решений"
        en: "Codeforces handle for submitting problems"
    codeforces_data_for_submitting_problems_password:
        ru: "Хендл (никнейм) на codeforces для отправки решений"
        en: "Codeforces handle for submitting problems"
    login_and_password_do_not_match:
        ru: "Пароль не подходит к логину"
        en: "The password does not match the login"
    unknown_error_check_internet:
        ru: "Неизвестная ошибка, проверьте подключение к интернету и перезагрузите страницу"
        en: "Unknown error, check your internet connection and reload the page"

export LangRaw = (id, lang) ->
    res = _LANG[id]?[lang]
    if not (res?) 
        throw "Unknown lang #{id} #{lang}"
    res

LangEl = withLang (props) ->
    LangRaw(props.id, props.lang)

export default Lang = (id) ->
    <LangEl id={id}/>