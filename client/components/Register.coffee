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
        <Grid fluid>
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
                <h3>Ваш аккаунт на informatics.mccme.ru</h3>
                <p>Вам надо иметь аккаунт на сайте <a href="http://informatics.mccme.ru">informatics.mccme.ru</a>;
                ваши программы будут реально проверяться именно там. Если у вас еще нет аккаунта на
                informatics, <a href="http://informatics.mccme.ru/login/signup.php">зарегистрируйтесь сейчас</a>.</p>

                <p>Ниже вы должны будете указать логин и пароль от informatics. Пароль будет храниться на algoprog.ru.
                Он нужен, чтобы отправлять решения задач от вашего имени.
                Если вы используете этот же пароль на других сайтах, не вводите его ниже
                — сначала смените пароль на informatics, и только потом продолжайте.
                Если вы не хотите, чтобы я имел доступ к вашему аккаунту на informatics,
                просто зарегистрируйте новый аккаунт там и укажите ниже именно его.</p>

                <FieldGroup
                    id="informatics-password"
                    label="Ваш логин на informatics"
                    type="text"/>
                <FieldGroup
                    id="informatics-password"
                    label="Ваш пароль на informatics"
                    type="password"/>

                <h2>Прочие данные</h2>
                <p>Они выгружаются из вашего аккаунта на informatics. Если они неверны,
                исправьте данные в вашем профиле там.</p>

                <h2>О вас</h2>
                <p>Напишите вкратце про себя. Как минимум — есть ли у вас опыт в программировании и какой;
                а также участвовали ли вы в олимпиадах по программированию и по математике.</p>

                <FormGroup controlId="aboutme">
                  <FormControl componentClass="textarea" placeholder="" />
                </FormGroup>

                <Button type="submit">
                    Зарегистрироваться
                </Button>
            </form>
        </Grid>
