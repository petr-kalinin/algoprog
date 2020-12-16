export default isContestRequired = (tableName) ->
    return tableName[4] != "*" and tableName[0] != "*"
