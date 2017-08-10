React = require('react')

import TableRow from './TableRow'

import globalStyles from './global.css'
import styles from './Table.css'

getHeader = (results) ->
    if not results
        return undefined
    res = []
    for table in results
        t = 
            _id: table._id
            results: []
        for subtable in table.results
            t.results.push
                _id: subtable._id
                name: subtable.name
                colspan: subtable.results.length
        res.push(t)
    return res

Text = (props) ->
    <div>
        <h1>Сводная таблица по уровням {props.levels}</h1>
        <p>Цвета:{" "}
            <span className={globalStyles.ac + " " + styles.example}>Зачтено/Принято</span>{" "} 
            <span className={globalStyles.ig + " " + styles.example}>Проигнорировано</span>{" "} 
            <span className={globalStyles.ok + " " + styles.example}>OK</span>{" "}
            <span className={globalStyles.wa + " " + styles.example}>Частичное решение и т.п.</span> 
        </p>
        <p>Наведите курсор на ячейку таблицы, чтобы узнать название задачи</p>
        <p>Двойной щелчок по ячейке таблицы открывает соответствующую задачу и, если по ней были посылки, то последнюю посылку по ней</p>
        <p>Имена школьников — ссылки на странички с результатами каждого конкретного школьника</p>
    </div>


export default Table = (props) ->
    if not props.data?.length
        return <table className={globalStyles.mainTable}/>

    header = getHeader(props.data[0].results)
    levels = (r._id for r in header).join(", ")
    
    <div>
        {props.headerText && <Text levels={levels} /> }
        <table className={globalStyles.mainTable}>
            <tbody>
                <TableRow details={props.details} header={true} results={header}/>
                {
                res = []
                a = (el) -> res.push(el)
                for result in props.data
                    a <TableRow details={props.details} user={result.user} results={result.results} key={result.user._id}/>
                res}
            </tbody>
        </table>
    </div>
