import fetch from 'isomorphic-fetch';
import {hasWsSetKey} from './WebsocketsSet'

port = (process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || '3000')
ip = (process.env.OPENSHIFT_NODEJS_IP || '127.0.0.1')
export API_URL = (if (typeof window == 'undefined') then ('http://' + ip + ':' + port) else '') + '/api/'
export WS_API_URL = (if window?.location?.protocol == "https:" then 'wss://' else 'ws://') + (if window? then (location.host) else '') + '/wsapi/'

export callWsApiWithBody = (endpoint, cb) ->
    if window?
        timeout = undefined
        wsCloseListener = () ->
            if not hasWsSetKey(endpoint)
                return
            ws = new WebSocket(WS_API_URL + endpoint)
            ws.onmessage = (msg) ->
                cb msg.data
            ws.onclose = ->
                setTimeout wsCloseListener, 20 * 1000
            timeout = setInterval ->
                  if not hasWsSetKey(endpoint)
                      clearInterval(timeout)
                      ws.close()
              , 5000
        wsCloseListener()

export callApiWithBody = (endpoint, method, headers, body) ->
    response = await fetch(API_URL + endpoint, {
        credentials: 'same-origin',
        method: method,
        headers,
        body
    })
    try
        return await response.json()
    catch
        return {}


export default callApi = (endpoint, data) ->
    method = if data then 'POST' else 'GET'
    headers = {
        'Content-Type': 'application/json'
    }
    body = JSON.stringify(data)
    return callApiWithBody(endpoint, method, headers, body)
