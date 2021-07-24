import blockIf from './blockIf'

isRegistered = (contestResults) ->
    return contestResults?.registered

export default needRegistration = (cls) ->
    return blockIf(cls, isRegistered, "Вы не зарегистрированы на контест")