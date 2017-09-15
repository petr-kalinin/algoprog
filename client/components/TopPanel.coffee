React = require('react')
FontAwesome = require('react-fontawesome')

import { LinkContainer } from 'react-router-bootstrap'

import Navbar from 'react-bootstrap/lib/Navbar'
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'

import UserName, {color} from './UserName'
import CfStatus from './CfStatus'

import styles from './TopPanel.css'

export default TopPanel = (props) ->
    <Navbar fixedTop fluid>
        <Navbar.Form pullLeft>
            <Button onClick={props.toggleTree}>{"\u200B"}<FontAwesome name="bars"/></Button>
        </Navbar.Form>
        <Navbar.Header>
            <Navbar.Brand>
                {
                if props.myUser?.user
                    <span>
                        <UserName user={props.myUser.user}/>
                        <span className={styles.separator}/>
                        <span title="Рейтинг" style={color: color(props.myUser.user)}>{props.myUser.user.rating}</span>
                        {" / "}
                        <span title="Активность">{props.myUser.user.activity}</span>
                        <span className={styles.separator}/>
                        <CfStatus cf={props.myUser.user.cf} />
                    </span>
                else
                    "Неизвестный пользователь"
                }
            </Navbar.Brand>
        </Navbar.Header>
        <Navbar.Form pullRight>
            {
            if props.me?._id
                <ButtonGroup>
                    <LinkContainer to="/profile" isActive={() -> false}>
                        <Button bsStyle="primary">
                            <FontAwesome name="cog"/> Профиль
                        </Button>
                    </LinkContainer>
                    <Button bsStyle="success">
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

###
        <Navbar.Collapse>
            <Navbar.Text>
                TestTestTest
            </Navbar.Text>
        </Navbar.Collapse>
###
