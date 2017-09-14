import Grid from 'react-bootstrap/lib/Grid'
import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Button from 'react-bootstrap/lib/Button'
React = require('react')

FieldGroup = ({ id, label, help, props... }) ->
    <FormGroup controlId={id}>
        <ControlLabel>{label}</ControlLabel>
        {`<FormControl {...props} />`}
        {help && <HelpBlock>{help}</HelpBlock>}
    </FormGroup>

export default class Register extends React.Component 
    render:  () ->
        <Grid>
            <h1>Регистрация</h1>
    
            <form action="/api/register" method="post">
                <FieldGroup 
                    id="username"
                    label="Имя пользователя"
                    type="text"/>
                <FieldGroup 
                    id="password"
                    label="Пароль"
                    type="password"/>
                <FieldGroup 
                    id="informatics-href"
                    label="Ссылка на вашу страницу на informatics.mccme.ru"
                    help="В правом верхнем углу любой странички на informatics нажмите на ссылку с вашим именем и вставьте сюда адрес странички, куда вы попали. Пример: http://informatics.mccme.ru/user/view.php?id=30282 или http://informatics.mccme.ru/user/view.php?id=30282&course=1135"
                    type="text"/>
                <Button type="submit">
                    Зарегистрироваться
                </Button>
            </form>
        </Grid>