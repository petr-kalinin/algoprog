import ConnectedComponent from './ConnectedComponent'

options =
    urls: (props) ->
        return {"myUser"}

    timeout: 20 * 1000

export default withMyUser = (Component) ->
    ConnectedComponent(Component, options)
