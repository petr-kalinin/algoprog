React = require('react')
import styles from './ShadowedSwitch.css'

export default ShadowedSwitch = (props) ->
    <span className={if props.on then styles.on else styles.off}>
        {props.children}
    </span>
