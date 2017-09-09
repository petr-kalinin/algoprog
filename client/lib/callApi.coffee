import fetch from 'isomorphic-fetch';

port = (process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || '3000')
ip = (process.env.OPENSHIFT_NODEJS_IP || '127.0.0.1')
export API_URL = (if (typeof window == 'undefined') then ('http://' + ip + ':' + port) else '') + '/api/'

export default callApi = (endpoint, data) ->
    method = if data then 'POST' else 'GET'
    response = await fetch(API_URL + endpoint, {
        credentials: 'same-origin',
        method: method,
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    try
        return await response.json()
    catch
        return {}
