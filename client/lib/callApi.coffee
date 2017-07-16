import fetch from 'isomorphic-fetch';

export API_URL = (if (typeof window == 'undefined') then 'http://localhost:3000' else '') + '/api/'

export default callApi = (endpoint) ->
    response = await fetch API_URL + endpoint
    return response.json()
