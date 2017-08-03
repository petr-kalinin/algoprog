React = require('react')

import TableRow from './TableRow'

import globalStyles from './global.css'

user1 =
    _id: "123456",
    name: "Василий Пупкин"
    level:
        current: "1А"
    rating: 123
    activity: 23.456
    cf:
        login: "abc"
        rating: 456
        color: "red"
        activity: 20
        progress: 100

user2 =
    _id: "123457",
    name: "Василий Пупкин2"
    level:
        current: "2А"
    rating: 123
    activity: 23.456
    cf:
        login: "abc"
        rating: 456
        color: "red"
        activity: 20
        progress: 100
    
tables = [{
        _id: "1А",
        tables: [{
            _id: "1А: фыв",
            name: "1А: ааа",
            results: [{
                _id: "123",
                table: "p123",
                problemName: "Задача 1",
                solved: 1,
                ok: 0,
                ignored: 0,
                attempts: 1,
                total: 1
            }, {
                _id: "456"
                table: "p456",
                problemName: "Задача 2"
                solved: 0,
                ok: 1,
                ignored: 0,
                attempts: 2
                total: 1
            }]
        }, {
            _id: "1А: ячс",
            name: "1А: ббб",
            results: [{
                _id: "789"
                table: "p789",
                problemName: "Задача 3"
                solved: 0,
                ok: 0,
                ignored: 1,
                attempts: 3
                total: 1
            }]
        }], 
    }, {
        _id: "1Б",
        tables: [{
            _id: "1Б: йцу",
            name: "1А: ввв",
            results: [{
                _id: "1"
                table: "p1",
                problemName: "Задача 4"
                solved: 0,
                ok: 0,
                ignored: 0,
                attempts: 4
                total: 1
            }]
        }, {
            _id: "1Б: фыв",
            name: "1А: ггг",
            results: [{
                _id: "2"
                table: "p2",
                problemName: "Задача 5",
                solved: 0,
                ok: 0,
                ignored: -10,
                attempts: 0
                total: 1
            }, {
                _id: "3"
                table: "p3",
                problemName: "Задача 6",
                solved: 1,
                ok: 0,
                ignored: 0,
                attempts: 0
                total: 1
            }]
        }]
    }]
            
data = [{
    user: user1,
    results: tables
}, {
    user: user2,
    results: tables
}]

getHeader = (results) ->
    if not results
        return undefined
    res = []
    for table in results
        t = 
            _id: table._id
            tables: []
        for subtable in table.tables
            t.tables.push
                _id: subtable._id
                name: subtable.name
                colspan: subtable.results.length
        res.push(t)
    return res

export default Table = (p) ->
    props = 
        results: data
    header = getHeader(props.results[0].results)
    <table className={globalStyles.mainTable}>
        <tbody>
            <TableRow details={true} header={true} tables={header}/>
            {
            res = []
            a = (el) -> res.push(el)
            for result in props.results
                a <TableRow details={true} user={result.user} tables={result.results} key={result.user._id}/>
            res}
        </tbody>
    </table>
