React = require('react')

import UserBadge from './UserBadge'
import SolvedByWeek from './SolvedByWeek'
import Table from './Table'

import { Badge } from 'react-bootstrap'

import globalStyles from './global.css'
import styles from './FullUser.css'

Chocos = (props) ->
    <div>
        <h2>Шоколадки</h2>
        <p className={global.small}>
            Первая строка: шоколадки за полные контесты: первая шоколадка за первый сданный полностью контест и далее по одной шоколадке каждый раз, когда число сданных контестов делится на три.
            Вторая строка: шоколадки за чистые контесты: за каждый контест, полностью сданный с первой попытки, одна шоколадка.
            Третья строка: шоколадки за почти чистые контесты: по шоколадке за каждые два контеста, в которых все задачи сданы не более чем со второй попытки, и при этом хотя бы одна задача сдана не с первой попытки.
        </p>
        <table className={styles.chocos_table}>
            <tbody>
                {
                res = []
                a = (el) -> res.push(el)
                for number, ci in props.chocos
                    a <tr key={ci}>
                        <td className={styles.chocos_td}>
                            {
                            if number
                                (<img src="/choco.png" key={n}/> for n in [1..number])
                            else
                                <img src="/choco-strut.png"/>
                            }
                        </td>
                        <td>
                            <Badge>
                                {number}
                            </Badge>
                        </td>
                    </tr>
                res}
            </tbody>
        </table>
    </div>

export default FullUser = (props) ->
    <div>
        {`<UserBadge {...props}/>`}
        {props.user.userList == "lic40" && <Chocos chocos={props.user.chocos}/> }
        <SolvedByWeek users={[props.user]} userList={props.user.userList} details={false} headerClass="h2"/>
        {
        res = []
        a =  (el) -> res.push(el)
        for result in props.results
            data =
                user: props.user
                results: result
            a <Table data={[data]} details={false} me={props.me} key={result[0]._id}/>
        res}
    </div>
