export default isPaid = (myUser) ->
    if !myUser?.paidTill
        return false
    # paidTill is for 0:00:00, but it is really paid until 23:59:59
    ms = new Date(myUser.paidTill).getTime() + 24 * 60 * 60 * 1000;
    realPaidTill = new Date(ms);
    return new Date() <= realPaidTill

isMuchUnpaid = (myUser) ->
    MAX_UNPAID_DAYS = 3
    if !myUser?.paidTill
        return false
    # paidTill is for 0:00:00, but it is really paid until 23:59:59
    ms = new Date(myUser.paidTill).getTime() + 24 * 60 * 60 * 1000 * (1 + MAX_UNPAID_DAYS);
    realPaidTill = new Date(ms);
    return new Date() > realPaidTill

export unpaidBlocked = (user) ->
    (user?.userList == "stud" || user?.userList == "notnnov") and (user?.paidTill) && (isMuchUnpaid(user))
