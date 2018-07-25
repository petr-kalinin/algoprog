React = require('react')
FontAwesome = require('react-fontawesome')
moment = require('moment')
deepEqual = require('deep-equal')

import { connect } from 'react-redux'

import { LinkContainer } from 'react-router-bootstrap'

import Navbar from 'react-bootstrap/lib/Navbar'
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import Modal from 'react-bootstrap/lib/Modal'

import { Link } from 'react-router-dom'

import * as actions from '../redux/actions'

import UserName, {color} from './UserName'
import CfStatus from './CfStatus'

import needUnknownWarning from '../lib/needUnknownWarning'
import isPaid, {unpaidBlocked} from '../lib/isPaid'
import ConnectedComponent from '../lib/ConnectedComponent'

import styles from './TopPanel.css'

needCfWarning = (user) ->
    (not user.cf?.login?) and (user.level.current >= "1В")

needUnpaidWarning = (user) ->
    (user?.userList == "stud" || user?.userList == "notnnov") and (user?.paidTill) && (not isPaid(user))

UnknownWarning = (props) ->
    <div className="static-modal">
        <Modal.Dialog>
            <Modal.Header>
                <Modal.Title>Учетная запись не активирована</Modal.Title>
            </Modal.Header>

            <Modal.Body>
                <div>
                    <p>Ваша учетная запись еще не активирована. Вы можете сдавать задачи, но напишите мне,
                    чтобы я активировал вашу учетную запись. Мои контакты — на страничке
                    {" "}<Link to="/material/0">О курсе</Link>.</p>
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
                            <b>Ваш аккаунт заблокирован до <Link to="/pay">полной оплаты</Link>.</b>
                        </p>
                    else
                        <p>
                            Вы можете пока решать задачи, но
                            {" "}<Link to="/pay">продлите оплату</Link> в ближайшее время.
                        </p>
                    }
                    <p>Если вы на самом деле оплачивали занятия, или занятия для вас должны быть бесплатными,
                    свяжитесь со мной.</p>
                </div>
            </Modal.Body>

            <Modal.Footer>
                <Button bsStyle="primary" onClick={if props.blocked then props.doLogout else props.handleClose}>OK</Button>
            </Modal.Footer>

        </Modal.Dialog>
    </div>


class TopPanel extends React.Component
    constructor: (props) ->
        super(props)
        @state =
            showWarning: (not @props.unknownWarningShown) and needUnknownWarning(@props.myUser)
            showUnpaid: ((not @props.unpaidWarningShown) and needUnpaidWarning(@props.myUser)) or unpaidBlocked(@props.myUser)
        @closeWarning = @closeWarning.bind(this)
        @openWarning = @openWarning.bind(this)
        @closeUnpaid = @closeUnpaid.bind(this)
        @openUnpaid = @openUnpaid.bind(this)

    closeWarning: ->
        @props.setUnknownWarningShown()
        @setState
            showWarning: false

    openWarning: ->
        @setState
            showWarning: true

    closeUnpaid: ->
        @props.setUnpaidWarningShown()
        @setState
            showUnpaid: false

    openUnpaid: ->
        @setState
            showUnpaid: true

    componentDidUpdate: (prevProps, prevState) ->
        newState =
            showWarning: (not @props.unknownWarningShown) and needUnknownWarning(@props.myUser)
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
                                <span title="Уровень">{@props.myUser.level.current}</span>
                                <span className={styles.separator}/>
                                <span title="Рейтинг" style={color: color(@props.myUser)}>{@props.myUser.rating}</span>
                                {" / "}
                                <span title="Активность">{@props.myUser.activity.toFixed(1)}</span>
                                <span className={styles.separator}/>
                                <CfStatus cf={@props.myUser.cf} />
                                {needCfWarning(@props.myUser) &&
                                    <span>
                                        <span title="Логин на codeforces неизвестен. Если вы там зарегистрированы, напишите логин мне.">CF: <FontAwesome name="question-circle"/></span>
                                        <span className={styles.separator}/>
                                    </span>}
                                {needUnknownWarning(@props.myUser) &&
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
            @state.showWarning && <UnknownWarning handleClose={@closeWarning}/>
            }
            {
            @state.showUnpaid && <UnpaidWarning handleClose={@closeUnpaid} doLogout={@props.logout} blocked={unpaidBlocked(@props.myUser)} myUser={@props.myUser}/>
            }
        </div>

options =
    urls: () ->
        {"me", "myUser"}
    timeout: 20000
    allowNotLoaded: true

ConnectedTopPanel = ConnectedComponent(TopPanel, options)

mapStateToProps = (state) ->
    return
        unknownWarningShown: state.unknownWarningShown
        unpaidWarningShown: state.unpaidWarningShown

doLogout = (dispatch) ->
    dispatch(actions.logout())
    dispatch(actions.setUnknownWarningShown(false))
    dispatch(actions.setUnpaidWarningShown(false))

mapDispatchToProps = (dispatch, ownProps) ->
    return
        logout: () -> doLogout(dispatch)
        setUnknownWarningShown: () -> dispatch(actions.setUnknownWarningShown())
        setUnpaidWarningShown: () -> dispatch(actions.setUnpaidWarningShown())

export default connect(mapStateToProps, mapDispatchToProps)(ConnectedTopPanel)
