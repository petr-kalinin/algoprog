import { GROUPS } from '../../client/lib/informaticsGroups'

export { GROUPS }

makeRequest = (adminUser, userId, groupName, urlAction, bodyAction) ->
    throw "Legacy; do not really move users to groups"

export addUserToGroup = (adminUser, userId, groupName) ->
    makeRequest(adminUser, userId, groupName, "add", "addParam")

export removeUserFromGroup = (adminUser, userId, groupName) ->
    makeRequest(adminUser, userId, groupName, "delete", "deleteParam")

export moveUserToGroup = (adminUser, userId, groupName) ->
    for name, id of GROUPS
        if name != groupName
            await removeUserFromGroup(adminUser, userId, name)
        else
            await addUserToGroup(adminUser, userId, name)
