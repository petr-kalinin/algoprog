import logger from '../log'

import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'
import TableResults from '../models/TableResults'
import {getTables, getUserResult} from '../api/table'
import {allTables} from '../materials/data/tables'

import addTotal from '../../client/lib/addTotal'
import awaitAll from '../../client/lib/awaitAll'

export default updateTableResults = (userId) ->
    logger.info "updating table results for user ", userId
    for table in allTables
        tables = await getTables(table)
        tableResults = await getUserResult(userId, tables, 1)
        if tableResults
            sumTable = new TableResults
                _id: "#{userId}::#{table}"
                user: userId
                table: table
                data: tableResults
            await sumTable.upsert()
    logger.info "updated table results for user ", userId
