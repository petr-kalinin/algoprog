React = require('react')
moment = require('moment')

import Table from 'react-bootstrap/lib/Table'

import outcomeToText from '../lib/outcomeToText'

import styles from './SubmitListTable.css'

export default SubmitListTable = (props) ->
    <div className={styles.outerDiv}>
        <Table responsive striped condensed hover>
            <thead>
                <tr>
                    <th>Время</th>
                    <th>Результат</th>
                    <th>&nbsp;</th>
                 </tr>
            </thead>
            <tbody>
                {props.submits?.map?((submit) =>
                    [cl, message] = outcomeToText(submit.outcome)
                    if submit._id == props.activeId
                        cl += " " + styles.active
                    <tr key={submit._id} className={cl}>
                        <td>{moment(submit.time).format('YYYY-MM-DD HH:mm:ss')}</td>
                        <td>{message}</td>
                        <td>{submit.language}</td>
                        <td><a onClick={props.handleSubmitClick(submit)} href="#">Подробнее</a></td>
                    </tr>
                ).reverse()}
            </tbody>
        </Table>
        {
        if props.submits?[0]
            infProblem = props.submits[0].problem.substr(1)
            <a href={"http://informatics.mccme.ru/moodle/mod/statements/view3.php?" + "chapterid=#{infProblem}&submit&user_id=#{props.submits[0].user}"} target="_blank">Попытки на информатикс</a>
        }
    </div>
