export default isContestRequired = (tableName) ->
    return tableName[4] != "*"
