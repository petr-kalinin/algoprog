React = require('react')
FontAwesome = require('react-fontawesome')

import { LinkContainer } from 'react-router-bootstrap'

import Navbar from 'react-bootstrap/lib/Navbar'
import Button from 'react-bootstrap/lib/Button'
import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'

export default TopPanel = (props) ->
    <Navbar fixedTop fluid>
        <Navbar.Form pullLeft>
            <Button onClick={props.toggleTree}>{"\u200B"}<FontAwesome name="bars"/></Button>
        </Navbar.Form>
        <Navbar.Header>
            <Navbar.Brand>
                <a href="#">Неизвестный пользователь</a>
            </Navbar.Brand>
        </Navbar.Header>
        <Navbar.Form pullRight>
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
        </Navbar.Form>
    </Navbar>

###
        <Navbar.Collapse>
            <Navbar.Text>
                TestTestTest
            </Navbar.Text>
        </Navbar.Collapse>
###
