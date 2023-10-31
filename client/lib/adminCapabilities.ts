export const CHECKINS = "checkins"
export const EDIT_PAGE = "edit_page"
export const ADD_BEST_SUBMITS = "add_best_submits"
export const SEE_BEST_SUBMITS = "see_best_submits"
export const SEE_FIND_MISTAKES = "see_find_mistakes"
export const SEE_START_LEVEL = "see_start_level"
export const EDIT_USER = "edit_user"
export const SEARCH_USERS = "search_users"
export const VIEW_SUBMITS = "view_submits"
export const SEE_SIMILAR_SUBMITS = "see_similar_submits"
export const SEE_LAST_COMMENTS = "see_last_comments"
export const REVIEW = "review"
export const VIEW_RECEIPT = "view_receipt"
export const MOVE_USER = "move_user"
export const MOVE_UNKNOWN_USER = "move_unknown_user"
export const SET_DORMANT = "set_dormant"
export const ACTIVATE = "activate"
export const TRANSLATE = "translate"
export const RESET_YEAR = "reset_year"
export const UPDATE_ALL = "update_all"
export const CREATE_TEAM = "create_team"
export const DOWNLOADING_STATS = "downloading_stats"
export const APPROVE_FIND_MISTAKE = "approve_find_mistake"

type Capability = typeof CHECKINS | typeof EDIT_PAGE | typeof SEE_BEST_SUBMITS

interface AdminUser {
    admin: boolean,
    adminData: {
        defaultUserLists: string[]
        capabilities: string[]
    }
}

function hasCapabilityImpl(capabilities: string[], capability: Capability): boolean {
    return capabilities.includes(capability) || capabilities.includes("*")
}

export default function hasCapability(user: AdminUser, capability: Capability): boolean {
    return user && user.admin && hasCapabilityImpl(user.adminData.capabilities, capability)
}

export function hasCapabilityForUserList(user: AdminUser, capability: Capability, userList: string): boolean {
    return user && user.admin && hasCapabilityImpl(user.adminData.capabilities, capability) && user.adminData.defaultUserLists.includes(userList)
}