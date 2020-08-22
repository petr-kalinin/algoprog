objectHasKeys = (object) ->
    return object? && Object.keys(object)?.length

export default needDeactivatedWarning = (myUser, me) ->
    return myUser && not me?.admin && not myUser?.activated && (myUser.rating > 0 || objectHasKeys(myUser.byWeek?.ok) || objectHasKeys(myUser.byWeek?.solved))
