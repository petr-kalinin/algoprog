React = require('react')
FontAwesome = require('react-fontawesome')

import { useState } from 'react'

import Button from 'react-bootstrap/lib/Button'
import Modal from 'react-bootstrap/lib/Modal'

import Lang from '../lang/lang'

import callApi from '../lib/callApi'

import Submit, {SubmitSource} from './Submit'

import styles from './BestSubmits.css'

export default BestSubmits = (props) ->
    [shouldReload, setShouldReload] = useState(false);
    setQuality = (submit, quality) ->
        () ->
            await callApi "setQuality/#{submit._id}/#{quality}", {}
            setShouldReload(true)

    <Modal show={true} onHide={props.close} dialogClassName={styles.modal}>
        <Modal.Body>
            <h2>{Lang("good_submits")}</h2>
            {
            props.submits.map((submit) ->
                <div key={submit._id} className={styles.submit}>
                    <SubmitSource submit={submit}/>
                    {props.stars && <div>
                        {props.admin && <FontAwesome name="times" key={0} onClick={setQuality(submit, 0)}/>}
                        {(<FontAwesome
                            name={"star" + (if x <= submit.quality then "" else "-o")}
                            key={x}
                            onClick={setQuality(submit, x)}/> \
                            for x in [1..5])}
                        {shouldReload && <span> Перезагрузите страницу, чтобы увидеть изменения</span>}
                    </div>}
                </div>
            )
            }
        </Modal.Body>

        <Modal.Footer>
            <Button bsStyle="primary" onClick={props.close}>{Lang("close")}</Button>
        </Modal.Footer>
    </Modal>
