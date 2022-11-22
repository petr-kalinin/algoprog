React = require('react')

import FormGroup from 'react-bootstrap/lib/FormGroup'
import FormControl from 'react-bootstrap/lib/FormControl'
import ControlLabel from 'react-bootstrap/lib/ControlLabel'
import HelpBlock from 'react-bootstrap/lib/HelpBlock'
import Alert from 'react-bootstrap/lib/Alert'

export default FieldGroup = ({ id, label, help, setField, state, validationState, error, props... }) =>
    onChange = (e) =>
        setField(id, e.target.value)
    value = if "value" of props then props.value else state[id]
    <FormGroup controlId={id} validationState={validationState}>
        {label && <ControlLabel>{label}</ControlLabel>}
        {if props.type == "radio" 
            props.children
        else
            `<FormControl {...props} value={value} onChange={onChange} name={id}/>`
        }
        {help && <HelpBlock>{help}</HelpBlock>}
        {error && <Alert  bsStyle="danger">{error}</Alert>}
    </FormGroup>
