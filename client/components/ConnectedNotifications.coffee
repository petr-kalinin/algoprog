import React from 'react';

import {connect} from 'react-redux';

import Notifications from 'react-notification-system-redux';

class ConnectedNotifications extends React.Component
    render: () ->
        <Notifications notifications={@props.notifications} />

export default connect(
    (state) -> ({ notifications: state.notifications })
)(ConnectedNotifications);
