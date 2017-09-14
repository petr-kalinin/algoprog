React = require('react')
FontAwesome = require('react-fontawesome')

import Navbar from 'react-bootstrap/lib/Navbar'
import Button from 'react-bootstrap/lib/Button'

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
        <Navbar.Collapse>
            <Navbar.Text>
                TestTestTest
            </Navbar.Text>
        </Navbar.Collapse>
    </Navbar>
