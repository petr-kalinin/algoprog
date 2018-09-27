objectHasKeys = (object) ->
    return object? && Object.keys(object)?.length

export default needUnknownWarning = (myUser) ->
    return myUser && not myUser.admin && myUser.userList == "unknown" && (myUser.rating > 0 || objectHasKeys(myUser.byWeek?.ok) || objectHasKeys(myUser.byWeek?.solved))
