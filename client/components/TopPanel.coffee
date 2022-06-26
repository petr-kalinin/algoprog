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
import LangSwitch from './LangSwitch'
import ThemeSwitch from './ThemeSwitch'
import TShirts from './TShirts'
import UserName, {color} from './UserName'

import Lang, {LangRaw} from '../lang/lang'

import ConnectedComponent from '../lib/ConnectedComponent'
import {getClassStartingFromJuly} from '../lib/graduateYearToClass'
import GROUPS from '../lib/groups'
import isPaid, {unpaidBlocked} from '../lib/isPaid'
import needDeactivatedWarning from '../lib/needDeactivatedWarning'
import withLang from '../lib/withLang'

import styles from './TopPanel.css'

needCfWarning = (user) ->
    (not user.cf?.login?) and (user.level.current >= "1В" || (user.level.current >= "1C" && user.level.current <= "1Z"))

needUnpaidWarning = (user) ->
    (GROUPS[user?.userList]?.paid) and (user?.paidTill) && (not isPaid(user))

DeactivatedWarning = (props) ->
    <div className="static-modal">
        <Modal.Dialog>
            <Modal.Header>
                <Modal.Title>{Lang("account_not_activated")}</Modal.Title>
            </Modal.Header>

            <Modal.Body>
                <div>
                    <p>{Lang("account_not_activated_long")}
                    <Link to="/material/about">{Lang("about_course_page")}</Link>.</p>
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
                <Modal.Title>{Lang("unpaid")}</Modal.Title>
            </Modal.Header>

            <Modal.Body>
                <div>
                    <p>{Lang("course_was_paid_only_until")}{moment(props.myUser.paidTill).format("DD.MM.YYYY")}.</p>
                    {if props.blocked
                        Lang("unpaid_blocked_long")
                    else
                        Lang("unpaid_not_blocked_long")
                    }
                    <p>{Lang("if_you_have_paid_contact_me")}</p>
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
                <Modal.Title>{Lang("account_not_activated")}</Modal.Title>
            </Modal.Header>

            <Modal.Body>
                <div>
                    <p>{Lang("account_not_activated_blocked_long")}
                    {" "}<Link to="/material/about">{Lang("about_course_page")}</Link>.</p>
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
                                <span title={LangRaw("class", @props.lang)}>{getClassStartingFromJuly(@props.myUser.graduateYear)}</span>
                                <span className={styles.separator}/>
                                <span title={LangRaw("level", @props.lang)}>{@props.myUser.level.current}</span>
                                <span className={styles.separator}/>
                                <span title={LangRaw("rating", @props.lang)} style={color: color(@props.myUser, @props.theme)}>{@props.myUser.rating}</span>
                                {" / "}
                                <span title={LangRaw("activity", @props.lang)}>{@props.myUser.activity.toFixed(1)}</span>
                                <span className={styles.separator}/>
                                <CfStatus cf={@props.myUser.cf} />
                                {needCfWarning(@props.myUser) &&
                                    <span>
                                        <span title={LangRaw("cf_login_unknown", @props.lang)}>CF: <FontAwesome name="question-circle"/></span>
                                        <span className={styles.separator}/>
                                    </span>}
                                <span className={styles.separator}/>
                                <TShirts user={@props.myUser} hideGot={true} title={LangRaw("you_have_tshirts", @props.lang)} onClick={(n)->window?.goto?("/material/tshirts")}/>
                                {needDeactivatedWarning(@props.myUser, @props.me) &&
                                    <span title={LangRaw("not_activated_top_panel", @props.lang)} className={"text-danger " + styles.warning} onClick={@openWarning}><FontAwesome name="exclamation-triangle"/></span>}
                                {needUnpaidWarning(@props.myUser) &&
                                    <span title={LangRaw("not_paid_top_panel", @props.lang)} className={"text-danger " + styles.warning} onClick={@openUnpaid}><FontAwesome name="exclamation-triangle"/></span>}
                            </span>
                        else
                            LangRaw("unknown_user", @props.lang)
                        }
                    </Navbar.Brand>
                </Navbar.Header>
                <Navbar.Form pullRight>
                    <ButtonGroup>
                        {<LangSwitch /> 
                        }
                        <ThemeSwitch /> 
                    </ButtonGroup>
                    <span className={styles.separator}/>
                    {
                    if @props.me?._id
                        <ButtonGroup>
                            <Button bsStyle="success" onClick={@props.logout}>
                                <FontAwesome name="sign-out"/> {LangRaw("sign_out", @props.lang)}
                            </Button>
                        </ButtonGroup>
                    else
                        <ButtonGroup>
                            <LinkContainer to="/register" isActive={() -> false}>
                                <Button bsStyle="primary">
                                    <FontAwesome name="user-plus"/> {LangRaw("register", @props.lang)}
                                </Button>
                            </LinkContainer>
                            <LinkContainer to="/login" isActive={() -> false}>
                                <Button bsStyle="success">
                                    <FontAwesome name="sign-in"/> {LangRaw("sign_in", @props.lang)}
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

ConnectedTopPanel = ConnectedComponent(withLang(withRouter(TopPanel)), options)

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
