React = require('react')
moment = require('moment')
FontAwesome = require('react-fontawesome')

import Table from 'react-bootstrap/lib/Table'

import ShadowedSwitch from './ShadowedSwitch'

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
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    {if props.handleDiffClick
                        <th>&nbsp;</th>
                    }
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
                        <td>{submit.comments?.length && <span title="Есть комментарии"><FontAwesome name="comment"/></span> || ""}</td>
                        <td><a onClick={props.handleSubmitClick(submit)} href="#">Подробнее</a></td>
                        {if props.handleDiffClick
                            <td>
                                <span onClick={props.handleDiffClick(0, submit)} href="#">
                                    <ShadowedSwitch on={props.activeDiffId[0] == submit._id}>
                                        <FontAwesome name="plus"/>
                                    </ShadowedSwitch>
                                </span>
                                <span onClick={props.handleDiffClick(1, submit)} href="#">
                                    <ShadowedSwitch on={props.activeDiffId[1] == submit._id}>
                                        <FontAwesome name="minus"/>
                                    </ShadowedSwitch>
                                </span>
                            </td>
                        }
                    </tr>
                ).reverse()}
            </tbody>
        </Table>
        {
        if props.submits?[0]
            infProblem = props.submits[0].problem.substr(1)
            <a href={"https://informatics.mccme.ru/moodle/mod/statements/view3.php?" + "chapterid=#{infProblem}&submit&user_id=#{props.submits[0].user}"} target="_blank">Попытки на информатикс</a>
        }
    </div>
