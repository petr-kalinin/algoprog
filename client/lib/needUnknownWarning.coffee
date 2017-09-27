export default needUnknownWarning = (myUser) ->
    return myUser && myUser.userList == "unknown" && (myUser.rating > 0 || (myUser.byWeek?.ok? && Object.keys(myUser.byWeek?.ok)?.length))
