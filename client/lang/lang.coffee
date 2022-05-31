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
        "en": "Your account was not activated yet. You can start solving the problems, but please contact me so that I activate your account. My contacts are on the "
    account_not_activated_blocked_long:
        "ru": "Ваша учетная запись еще не активирована. Если вы хотите заниматься, напишите мне, чтобы я активировал вашу учетную запись. Мои контакты — на страничке "
        "en": "Your account was not activated yet. Please contact me so that I activate your account. My contacts are on the "
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
        "en": "You have earned a tshirt. Please contact me to know how you can get it."
    not_activated_top_panel:
        ru: "Учетная запись не активирована, напишите мне"
        en: "Account not activated, please contact me"
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
    copy:
        ru: "Скопировать"
        en: "Copy"
    copied:
        ru: "Скопировано"
        en: "Copied"
    find_mistake:
        ru: "Найди ошибку"
        en: "Find a bug"
    about_find_mistake:
        ru: "О поиске ошибок"
        en: "About 'find a bug'"
    reset_changes:
        ru: "Сбросить правки"
        en: "Reset changes"
    changes_of_allowed:
        ru: (currentDistance, maxSubmits) -> "Исправлений: #{currentDistance} (можно #{maxSubmits})"
        en: (currentDistance, maxSubmits) -> "Changed: #{currentDistance} (allowed #{maxSubmits})"
    sort_by_problem:
        ru: "Сортировать по задаче"
        en: "Sort by problem"
    sort_by_status:
        ru: "Сортировать по статусу"
        en: "Sort by status"
    hide_submits:
        ru: "Спрятать посылки"
        en: "Hide submits"
    results:
        ru: "Результаты"
        en: "Results"
    cant_pay_not_registered:
        ru: "Вы не зарегистрированы, вы не можете оплачивать занятия. Форма ниже приведена для примера."
        en: "You are not registered, you cannot pay for the course. The form below is given as an example."
    cant_pay_not_activated:
        ru: "Ваш аккаунт не активирован. Напишите мне, чтобы я активировал ваш аккаунт и установил стоимость занятий. Форма ниже приведена для примера."
        en: "Your account is not activated. Plase contact me so that I activate your account and set the cost of the course. The form below is given as an example."
    cant_pay_free:
        ru: "Занятия для вас бесплатны, вам не надо их оплачивать."
        en: "The course is free for you, you don't need to pay."
    cant_pay_no_price:
        ru: "Для вас не указана стоимость занятий, напишите мне. Форма ниже приведена для примера."
        en: "The cost of classes is not indicated for you, please contact me. The form below is given as an example."
    payment_for_the_course:
        ru: "Оплата занятий"
        en: "Payment for the course"
    you_pay_for_one_month:
        ru: (amount) -> "Вы оплачиваете один месяц занятий на algoprog.ru. Стоимость месяца для вас составляет #{amount} рублей."
        en: (amount) -> "You pay for one month access to algoprog.org. The price for you is #{amount} rubles."
    payment_is_possible_only_from_russian_banks:
        ru: "Оплата возможна только с карт российских банков. Если у вас нет таких карт, возможны другие варианты (банковским переводом по российским реквизитам, SWIFT-переводом, биткойнами), напишите мне."
        en: "Payment is possible only with cards issued by Russian banks. If you do not have such cards, other options are possible (by bank transfer using Russian bank details, by SWIFT transfer, bitcoin), please contact me."
    payment_sum:
        ru: "Сумма"
        en: "Sum"
    full_payer_name:
        ru: "Полные ФИО плательщика"
        en: "Full name of the payer"
    payer_email:
        ru: "E-mail плательщика"
        en: "Payer email"
    you_agree_to_oferta:
        ru: "Нажимая «Оплатить», вы соглашаетесь с <a href='/oferta.pdf' target='_blank'>офертой</a> оказания услуг."
        en: ""
    do_pay:
        ru: "Оплатить"
        en: "Pay"
    payment_official: 
        ru: <>
                <h2>Официальная часть</h2>
                <p>Получатель платежа — ИП Калинин Петр Андреевич, ОГРНИП 318527500120581, ИНН 526210494064. 
                Контакты: petr@kalinin.nnov.ru, +7-910-794-32-07. (Полностью контакты указаны в разделе <Link to="/material/about">О курсе</Link>.)</p>
                <p>Платежи осуществляются через Тинькофф Банк. Принимаются карты любых российских банков.</p>
                <img height="30px" src="/tinkoff.png" style={{marginRight: "15px"}}/>
                <img height="30px" src="/mastercard_visa.svg"/>            
            </>
        en: <>
                <p>TBD</p>
            </>
    payment_successful_message:
        ru: <>
                <h1>Оплата успешна</h1>
                <p>Оплата занятий успешна, срок занятий на сайте будет продлен в ближайшее время после обработки платежа.
                Обычно обработка занимает несколько секунд, в особых случаях может продолжаться несколько часов.
                Если через два часа срок оплаченных занятий не будет продлен, свяжитесь со мной.</p>

                <p>Чек об оплате (в соответствии с законом о самозанятых; чек может появиться не сразу, а через 20-30 секунд):</p>
            </>
        en: <>
                <h1>Payment successful</h1>
                <p>The payment for course is successful, the paid-for period will be extended in the near future after the payment is processed.
                Usually processing takes a few seconds, in some cases it can take several hours.
                If the paid-for period is not extended after two hours, please contact me.</p>
                <p>The receipt (according to Russia tax law; it may take 20-30 seconds to appear):</p>
            </>
    solved_problems_by_week:
        ru: "Сданные задачи по неделям"
        en: "Solved problems by week"
    solved_by_week_notes:
        ru: <>
                <p className="small">Количество зачтенных посылок за неделю; 0.5, если посылки были, но ни одной зачтенной</p>
                <p className="small"><b>Таблица развернута: ось времени направлена влево, недавние недели находятся слева.</b></p>            
            </> 
        en: <>
                <p className="small">The number of accepted submits for each  week; 0.5 if there were submits, but none were accepted.</p>
                <p className="small"><b>The table is reversed: the time axis is directed to the left, recent weeks are on the left.</b></p>            
            </> 
    download:
        ru: "Скачать"
        en: "Download"
    source_code:
        ru: "Исходный код"
        en: "Source"
    comments:
        ru: "Комментарии"
        en: "Comments"
    compiler_output:
        ru: "Вывод компилятора"
        en: "Compiler output"
    result:
        ru: "Результат"
        en: "Outcome"
    time:
        ru: "Время"
        en: "Time"
    memory:
        ru: "Память"
        en: "Memory"
    you_have_already_submitted:
        ru: "Вы уже отправляли это код"
        en: "You have already submitted this code"
    account_blocked_unpaid:
        ru: "Ваш аккаунт заблокирован за неуплату"
        en: "You account is blocked due to no payment"
    account_not_activated:
        ru: "Ваш аккаунт не активирован"
        en: "Your account is not activated"
    unknown_error:
        ru: "Неопознанная ошибка"
        en: "Unknown error"
    submit_solution:
        ru: "Отправить решение"
        en: "Submit a solution"
    code_editor:
        ru: "Редактор кода"
        en: "Code editor"
    send_as_draft:
        ru: "Отправить как черновик, не тестировать"
        en: "Send as draft, do not test"
    do_submit:
        ru: "Отправить"
        en: "Submit"
    submit_disclaimer:
        ru: "Отправляя решение на проверку, я предоставляю администраторам сайта неограниченную лицензию на использование исходного кода решения в любых целях, включая, но не ограничиваясь, использование решения в разделе «Хорошие решения», «Найди ошибку» и т.д."
        en: "By submitting the solution, I grant the site administrators an unlimited license to use the source code of the solution for any purpose, including, but not limited to, using the solution in the section 'Good Solutions', 'Find a bug', etc."
    draft_explained:
        ru: "Решение будет отправлено как черновик. Оно будет сохранено на сервере и доступно в списке посылок, но не будет протестировано и не будет влиять на результаты по этой задаче. Например, это вам может быть полезно, если вы хотите продолжить работу над задачей с другого компьютера."
        en: "The solution will be sent as a draft. It will be saved on the server and will be available in the submission list, but it will not be tested and will not affect the results for this problem. For example, this may be useful to you if you want to continue working on a problem from another computer."
    successfully_submitted:
        ru: "Решение успешно отправлено."
        en: "The solution has been successfully submitted"
    submit_error:
        ru: "Ошибка отправки"
        en: "An error occured during submission"

export LangRaw = (id, lang) ->
    res = _LANG[id]?[lang]
    if not (res?) 
        throw "Unknown lang #{id} #{lang}"
    res

LangEl = withLang (props) ->
    LangRaw(props.id, props.lang)

export default Lang = (id) ->
    <LangEl id={id}/>