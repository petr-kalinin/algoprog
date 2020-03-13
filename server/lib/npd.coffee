import download from './download'

import Config from '../models/Config'

API_PROVIDER = 'https://lknpd.nalog.ru/api/v1/'
export INN = process.env["INN"]

MOSCOW_OFFSET = -3 * 60 * 60 * 1000
MOSCOW_ZONE = '+03:00'

export callApiRaw = (endpoint, data, headers = {}) ->
    headers['Content-Type'] = 'application/json'
    body = data
    url = "#{API_PROVIDER}#{endpoint}"
    result = await download url, null, {method: "POST", headers, body, maxAttempts: 1, json: true}
    return result

updateToken = () ->
    data = await Config.get("npd.baseData")
    refreshToken = await Config.get("npd.refreshToken")
    data.refreshToken = refreshToken
    res = await callApiRaw('auth/token', data)
    await Config.set("npd.refreshToken", res.refreshToken)
    await Config.set("npd.token", res.token)
    await Config.set("npd.tokenExpireIn", res.tokenExpireIn)

getToken = () ->
    tokenExpireIn = await Config.get("npd.tokenExpireIn")
    if (not tokenExpireIn) or (tokenExpireIn - new Date() < 10 * 1000)
        await updateToken()
    return await Config.get("npd.token")

export callApi = (endpoint, data) ->
    headers = {"Authorization": "Bearer "+ await getToken()}
    return callApiRaw(endpoint, data, headers)

export addIncome = (service, amount) ->
    date = new Date()
    date = new Date(+date - MOSCOW_OFFSET).toISOString().slice(0, -1) + MOSCOW_ZONE
    data = {
        ignoreMaxTotalIncomeRestriction: false,
        operationTime: date,
        paymentType: "CASH",
        requestTime: date,
        services: [
            {
                "amount": amount,
                "name": service,
                "quantity": 1
            }
        ],
        totalAmount: amount
    }
    res = await callApi('income', data)
    return res.approvedReceiptUuid
