import { GROUPS } from '../../client/lib/informaticsGroups'

export { GROUPS }

makeRequest = (adminUser, userId, groupName, urlAction, bodyAction) ->
    groupId = GROUPS[groupName]
    href = "http://informatics.mccme.ru/moodle/ajax/ajax.php?sid=&objectName=group&objectId=#{groupId}&selectedName=users&action=#{urlAction}"
    body = "#{bodyAction}={\"id\":\"#{userId}\"}&group_id=&session_sid="
    _debug_marker = {qwe: '211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211_211'}
    await adminUser.download(href, {
        method: 'POST',
        headers: {'Content-Type': "application/x-www-form-urlencoded; charset=UTF-8"},
        body: body,
        followAllRedirects: true
    })

export addUserToGroup = (adminUser, userId, groupName) ->
    makeRequest(adminUser, userId, groupName, "add", "addParam")

export removeUserFromGroup = (adminUser, userId, groupName) ->
    makeRequest(adminUser, userId, groupName, "delete", "deleteParam")

export moveUserToGroup = (adminUser, userId, groupName) ->
    for name, id of GROUPS
        if name != groupName
            _debug_marker = {qwe: '212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212_212'}
            await removeUserFromGroup(adminUser, userId, name)
        else
            _debug_marker = {qwe: '213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213_213'}
            await addUserToGroup(adminUser, userId, name)
