import download from './download'

API_PROVIDER = 'https://lknpd.nalog.ru/api/v1/'
REFRESH_TOKEN = process.env["NPD_REFRESH_TOKEN"]
export INN = process.env["INN"]

MOSCOW_OFFSET = -3 * 60 * 60 * 1000
MOSCOW_ZONE = '+03:00'

export callApiRaw = (endpoint, data) ->
    headers = 
        'Content-Type': 'application/json'
    body = data
    url = "#{API_PROVIDER}#{endpoint}"
    result = await download url, null, {method: "POST", headers, body, maxAttempts: 1, json: true}
    console.log "#{url} -> #{result}"
    try
        return result
    catch
        return {}

getToken = () ->
    data = {
        "deviceInfo": {
            "analytics": {
                "analyticsDeviceId": "e216f655bbe0aa08",
                "platform": "AppMetrica"
            },
            "appVersion": "2.0.1",
            "metaDetails": {
                "browser": "",
                "browserVersion": "",
                "os": "android"
            },
            "pushProviderToken": "",
            "sourceDeviceId": "e216f655bbe0aa08",
            "sourceType": "android"
        },
        "refreshToken": REFRESH_TOKEN
    }
    res = await callApiRaw('auth/token', data)
    console.log "token -> #{res}"
    return res.token

export callApi = (endpoint, data) ->
    data.Authorization = "Bearer "+ await getToken()
    return callApiRaw(endpoint, data)

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
    console.log "income -> #{res}"
    return res.approvedReceiptUuid
