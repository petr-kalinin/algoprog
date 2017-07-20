import fetch from 'isomorphic-fetch';

port = (process.env.OPENSHIFT_NODEJS_PORT || '3000')
ip = (process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0')
export API_URL = (if (typeof window == 'undefined') then ('http://' + ip + ':' + port) else '') + '/api/'

export default callApi = (endpoint) ->
    response = await fetch API_URL + endpoint
    return response.json()
