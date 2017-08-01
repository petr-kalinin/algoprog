React = require('react')

import TableRow from './TableRow'

import globalStyles from './global.css'

export default Table = (p) ->
    <table className={globalStyles.mainTable}>
        <tbody>
            <TableRow />
        </tbody>
    </table>
