React = require('react')
FontAwesome = require('react-fontawesome')
moment = require('moment')
deepEqual = require('deep-equal')

import { connect } from 'react-redux'

import { LinkContainer } from 'react-router-bootstrap'
import { withRouter } from "react-router"

import Navbar from 'react-bootstrap/lib/Navbar'
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import Modal from 'react-bootstrap/lib/Modal'

import { Link } from 'react-router-dom'

import * as actions from '../redux/actions'

import CfStatus from './CfStatus'
import ThemeSwitch from './ThemeSwitch'
import TShirts from './TShirts'
import UserName, {color} from './UserName'

import ConnectedComponent from '../lib/ConnectedComponent'
import {getClassStartingFromJuly} from '../lib/graduateYearToClass'
import isPaid, {unpaidBlocked} from '../lib/isPaid'
import needDeactivatedWarning from '../lib/needDeactivatedWarning'

import styles from './TopPanel.css'

needCfWarning = (user) ->
    (not user.cf?.login?) and (user.level.current >= "1В")

needUnpaidWarning = (user) ->
    (user?.userList == "stud" || user?.userList == "notnnov") and (user?.paidTill) && (not isPaid(user))

DeactivatedWarning = (props) ->
    <div className="static-modal">
        <Modal.Dialog>
            <Modal.Header>
                <Modal.Title>Учетная запись не активирована</Modal.Title>
            </Modal.Header>

            <Modal.Body>
                <div>
                    <p>Ваша учетная запись еще не активирована. Вы можете сдавать задачи, но напишите мне,
                    чтобы я активировал вашу учетную запись. Мои контакты — на страничке
                    {" "}<Link to="/material/about">О курсе</Link>.</p>
                </div>
            </Modal.Body>

            <Modal.Footer>
                <Button bsStyle="primary" onClick={props.handleClose}>OK</Button>
            </Modal.Footer>

        </Modal.Dialog>
    </div>

UnpaidWarning = (props) ->
    if not props.myUser
        return null
    <div className="static-modal">
        <Modal.Dialog>
            <Modal.Header>
                <Modal.Title>Занятия не оплачены</Modal.Title>
            </Modal.Header>

            <Modal.Body>
                <div>
                    <p>Ваши занятия оплачены только до {moment(props.myUser.paidTill).format("DD.MM.YYYY")}.</p>
                    {if props.blocked
                        <p>
                            Оплата просрочена более чем на 3 дня. <b>Ваш аккаунт заблокирован до <Link to="/payment">полной оплаты</Link>.</b>
                        </p>
                    else
                        <p>
                            Вы можете пока решать задачи, но
                            {" "}<Link to="/payment">продлите оплату</Link> в ближайшее время.
                        </p>
                    }
                    <p>Если вы на самом деле оплачивали занятия, или занятия для вас должны быть бесплатными,
                    свяжитесь со мной.</p>
                </div>
            </Modal.Body>

            <Modal.Footer>
                <Button bsStyle="primary" onClick={props.handleClose}>OK</Button>
            </Modal.Footer>

        </Modal.Dialog>
    </div>

DormantWarning = (props) ->
    <div className="static-modal">
        <Modal.Dialog>
            <Modal.Header>
                <Modal.Title>Учетная запись не активирована</Modal.Title>
            </Modal.Header>

            <Modal.Body>
                <div>
                    <p>Ваша учетная запись еще не активирована. Если вы хотите заниматься, напишите мне,
                    чтобы я активировал вашу учетную запись. Мои контакты — на страничке
                    {" "}<Link to="/material/about">О курсе</Link>.</p>
                </div>
            </Modal.Body>

            <Modal.Footer>
                <Button bsStyle="primary" onClick={props.handleClose}>OK</Button>
            </Modal.Footer>

        </Modal.Dialog>
    </div>


class TopPanel extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            showWarning: (not @props.deactivatedWarningShown) and needDeactivatedWarning(@props.myUser, @props.me)
            showUnpaid: ((not @props.unpaidWarningShown) and needUnpaidWarning(@props.myUser)) or (unpaidBlocked(@props.myUser) and @props.history.location.pathname != "/payment")
        @closeWarning = @closeWarning.bind(this)
        @openWarning = @openWarning.bind(this)
        @closeUnpaid = @closeUnpaid.bind(this)
        @openUnpaid = @openUnpaid.bind(this)

    closeWarning: ->
        @props.setDeactivatedWarningShown()
        @setState
            showWarning: false

    openWarning: ->
        @setState
            showWarning: true

    closeUnpaid: ->
        @props.setUnpaidWarningShown()
        @setState
            showUnpaid: false
        if unpaidBlocked(@props.myUser)
            @props.history.push("/payment")

    openUnpaid: ->
        @setState
            showUnpaid: true

    componentDidUpdate: (prevProps, prevState) ->
        newState =
            showWarning: (not @props.deactivatedWarningShown) and needDeactivatedWarning(@props.myUser, @props.me)
            showUnpaid: ((not @props.unpaidWarningShown) and needUnpaidWarning(@props.myUser)) or unpaidBlocked(@props.myUser)
        if !deepEqual(newState, prevState)
            @setState(newState)

    render: ->
        <div>
            <Navbar fixedTop fluid>
                <Navbar.Form pullLeft>
                    <Button onClick={@props.toggleTree}>{"\u200B"}<FontAwesome name="bars"/></Button>
                </Navbar.Form>
                <Navbar.Header>
                    <Navbar.Brand>
                        {@props.me?.admin && <span className={styles.adminhash}><FontAwesome name="hashtag"/></span>}
                        {
                        if @props.myUser?.name
                            <span>
                                <UserName user={@props.myUser}/>
                                <span className={styles.separator}/>
                                <span title="Класс">{getClassStartingFromJuly(@props.myUser.graduateYear)}</span>
                                <span className={styles.separator}/>
                                <span title="Уровень">{@props.myUser.level.current}</span>
                                <span className={styles.separator}/>
                                <span title="Рейтинг" style={color: color(@props.myUser, @props.theme)}>{@props.myUser.rating}</span>
                                {" / "}
                                <span title="Активность">{@props.myUser.activity.toFixed(1)}</span>
                                <span className={styles.separator}/>
                                <CfStatus cf={@props.myUser.cf} />
                                {needCfWarning(@props.myUser) &&
                                    <span>
                                        <span title="Логин на codeforces неизвестен. Если вы там зарегистрированы, укажите логин в своём профиле.">CF: <FontAwesome name="question-circle"/></span>
                                        <span className={styles.separator}/>
                                    </span>}
                                <span className={styles.separator}/>
                                <TShirts user={@props.myUser} hideGot={true} title="У вас есть неполученные футболки. Напишите мне, чтобы их получить." onClick={(n)->window?.goto?("/material/tshirts")}/>
                                {needDeactivatedWarning(@props.myUser, @props.me) &&
                                    <span title="Учетная запись не активирована, напишите мне" className={"text-danger " + styles.warning} onClick={@openWarning}><FontAwesome name="exclamation-triangle"/></span>}
                                {needUnpaidWarning(@props.myUser) &&
                                    <span title="Занятия не оплачены" className={"text-danger " + styles.warning} onClick={@openUnpaid}><FontAwesome name="exclamation-triangle"/></span>}
                            </span>
                        else
                            "Неизвестный пользователь"
                        }
                    </Navbar.Brand>
                </Navbar.Header>
                <Navbar.Form pullRight>
                    <ThemeSwitch /> 
                    <span className={styles.separator}/>
                    {
                    if @props.me?._id
                        <ButtonGroup>
                            <Button bsStyle="success" onClick={@props.logout}>
                                <FontAwesome name="sign-out"/> Выход
                            </Button>
                        </ButtonGroup>
                    else
                        <ButtonGroup>
                            <LinkContainer to="/register" isActive={() -> false}>
                                <Button bsStyle="primary">
                                    <FontAwesome name="user-plus"/> Регистрация
                                </Button>
                            </LinkContainer>
                            <LinkContainer to="/login" isActive={() -> false}>
                                <Button bsStyle="success">
                                    <FontAwesome name="sign-in"/> Вход
                                </Button>
                            </LinkContainer>
                        </ButtonGroup>
                    }
                </Navbar.Form>
            </Navbar>
            {
            @props.myUser?.dormant && <DormantWarning handleClose={@props.logout}/>
            }
            {
            not @props.myUser?.dormant and @state.showWarning && <DeactivatedWarning handleClose={@closeWarning}/>
            }
            {
            not @props.myUser?.dormant and @state.showUnpaid && <UnpaidWarning handleClose={@closeUnpaid} blocked={unpaidBlocked(@props.myUser)} myUser={@props.myUser}/>
            }
        </div>

options =
    urls: () ->
        {"me", "myUser"}
    timeout: 20000
    allowNotLoaded: true

ConnectedTopPanel = ConnectedComponent(withRouter(TopPanel), options)

mapStateToProps = (state) ->
    return
        theme: state.theme
        deactivatedWarningShown: state.deactivatedWarningShown
        unpaidWarningShown: state.unpaidWarningShown

doLogout = (dispatch) ->
    dispatch(actions.logout())
    dispatch(actions.setDeactivatedWarningShown(false))
    dispatch(actions.setUnpaidWarningShown(false))

mapDispatchToProps = (dispatch, ownProps) ->
    return
        logout: () -> doLogout(dispatch)
        setDeactivatedWarningShown: () -> dispatch(actions.setDeactivatedWarningShown())
        setUnpaidWarningShown: () -> dispatch(actions.setUnpaidWarningShown())

export default connect(mapStateToProps, mapDispatchToProps)(ConnectedTopPanel)
