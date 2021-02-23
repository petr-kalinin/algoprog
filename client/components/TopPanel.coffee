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

import UserName, {color} from './UserName'
import ThemeSwitch from './ThemeSwitch'
import ConnectedComponent from '../lib/ConnectedComponent'

import styles from './TopPanel.css'

###
needCfWarning = (user) ->
    (not user.cf?.login?) and (user.level.current >= "1В")

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
                    {" "}<Link to="/material/0">О курсе</Link>.</p>
                </div>
            </Modal.Body>

            <Modal.Footer>
                <Button bsStyle="primary" onClick={props.handleClose}>OK</Button>
            </Modal.Footer>

        </Modal.Dialog>
    </div>
###


class TopPanel extends React.Component
    ###
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
    ###

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
            {###
            {
            @props.myUser?.dormant && <DormantWarning handleClose={@props.logout}/>
            }
            {
            not @props.myUser?.dormant and @state.showWarning && <DeactivatedWarning handleClose={@closeWarning}/>
            }
            {
            not @props.myUser?.dormant and @state.showUnpaid && <UnpaidWarning handleClose={@closeUnpaid} blocked={unpaidBlocked(@props.myUser)} myUser={@props.myUser}/>
            }
            ###}
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

doLogout = (dispatch) ->
    dispatch(actions.logout())
    dispatch(actions.setDeactivatedWarningShown(false))

mapDispatchToProps = (dispatch, ownProps) ->
    return
        logout: () -> doLogout(dispatch)
        setDeactivatedWarningShown: () -> dispatch(actions.setDeactivatedWarningShown())

export default connect(mapStateToProps, mapDispatchToProps)(ConnectedTopPanel)
