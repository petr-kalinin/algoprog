import withMyUser from './withMyUser'
import ConnectedComponent from './ConnectedComponent'

options =
    urls: (props) ->
        if props.myUser?._id
            "myResults": "userResults/#{props.myUser._id}"
        else
            {}

    timeout: 20000

    allowNotLoaded: true

export default withMyResults = (Component) ->
    withMyUser(ConnectedComponent(Component, options))
