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
        "en": "About license for site materials"
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
    

export LangRaw = (id, lang) ->
    res = _LANG[id]?[lang]
    if not (res?) 
        throw "Unknown lang #{id} #{lang}"
    res

LangEl = withLang (props) ->
    LangRaw(props.id, props.lang)

export default Lang = (id) ->
    <LangEl id={id}/>