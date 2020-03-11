import download from './download'

API_PROVIDER = 'https://lknpd.nalog.ru/api/v1/'
BEARER = process.env["NPD_BEARER"]

MOSCOW_OFFSET = -3 * 60 * 60 * 1000
MOSCOW_ZONE = '+03:00'

export callApi = (endpoint, data) ->
    headers = 
        Authorization: "Bearer "+BEARER
        'Content-Type': 'application/json'
    body = data
    url = "#{API_PROVIDER}#{endpoint}"
    result = await download url, null, {method: "POST", headers, body, maxAttempts: 1, json: true}
    try
        return result
    catch
        return {}

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
