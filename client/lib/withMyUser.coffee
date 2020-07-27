import ConnectedComponent from './ConnectedComponent'

options =
    urls: (props) ->
        return {"myUser", "me"}

    timeout: 20 * 1000

export default withMyUser = (Component) ->
    ConnectedComponent(Component, options)
