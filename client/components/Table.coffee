React = require('react')

import TableRow from './TableRow'

import globalStyles from './global.css'

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

export default Table = (props) ->
    if not props.data?.length
        return <table className={globalStyles.mainTable}/>

    header = getHeader(props.data[0].results)
    <table className={globalStyles.mainTable}>
        <tbody>
            <TableRow details={true} header={true} results={header}/>
            {
            res = []
            a = (el) -> res.push(el)
            for result in props.data
                a <TableRow details={true} user={result.user} results={result.results} key={result.user._id}/>
            res}
        </tbody>
    </table>
