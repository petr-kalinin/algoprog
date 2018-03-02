React = require('react')
FontAwesome = require('react-fontawesome')

import Button from 'react-bootstrap/lib/Button'
import Modal from 'react-bootstrap/lib/Modal'

import Submit, {SubmitSource} from './Submit'

import styles from './BestSubmits.css'

export default BestSubmits = (props) ->
    <Modal show={true} onHide={props.close} dialogClassName={styles.modal}>
        <Modal.Body>
            <h2>Лучшие решения</h2>
            {
            props.submits.map((submit) ->
                <div key={submit._id} className={styles.submit}>
                    <SubmitSource submit={submit}/>
                    {props.stars && (<FontAwesome
                        name={"star" + (if x <= submit.quality then "" else "-o")}
                        key={x}/> \
                        for x in [1..5])}
                </div>
            )
            }
        </Modal.Body>

        <Modal.Footer>
            <Button bsStyle="primary" onClick={props.close}>Закрыть</Button>
        </Modal.Footer>
    </Modal>
