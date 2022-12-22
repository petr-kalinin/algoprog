React = require('react')
moment = require('moment')

import Col from 'react-bootstrap/lib/Col'
import Grid from 'react-bootstrap/lib/Grid'
import Row from 'react-bootstrap/lib/Row'
import Table from 'react-bootstrap/lib/Table'
import { Helmet } from "react-helmet"
import { withRouter } from 'react-router'
import { Link } from 'react-router-dom'

import ConnectedComponent from '../lib/ConnectedComponent'

import styles from './Invoice.css'

Invoice = (props) ->
    invoice = props.invoice
    <>
        <Helmet>
            <title>{"Invoice # #{invoice.orderId}"}</title>
        </Helmet>
        <Grid>
        <Row>
        <Col xs={12} sm={6}>
            <div dangerouslySetInnerHTML={{__html: invoice.ip_data}} id={styles.ip_data}></div>
        </Col>
        <Col xsHidden sm={6}>
            <div id={styles.invoice_data_md}>
                <div><b>INVOICE</b> # {invoice.orderId}</div>
                <div>{moment(invoice.date).format('DD.MM.YY HH:mm:ss')}</div>
            </div>
        </Col>
        <Col xs={12} smHidden mdHidden lgHidden>
            <div id={styles.invoice_data_xs}>
                <div><b>INVOICE</b> # {invoice.orderId}</div>
                <div>{moment(invoice.date).format('DD.MM.YY HH:mm:ss')}</div>
            </div>
        </Col>
        <Col xs={12}>
            <div id={styles.header}><b>BILL TO: {invoice.userName}</b> {invoice.userEmail}</div>
        </Col>
        <Col xs={12}>
            <div>
                <Table striped bordered condensed hover>
                <thead>
                <tr>
                    <th>Description</th>
                    <th>Rate</th>
                    <th>Qty</th>
                    <th>Amount</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>One month of study on algoprog.org</td>
                    <td>{invoice.currency} {invoice.amount}</td>
                    <td>1</td>
                    <td><b>{invoice.currency} {invoice.amount}</b></td>
                </tr>
                </tbody>
                </Table>
            </div>
        </Col>

        <Col xs={12} sm={6}>
            <div id={styles.total}>
                <b>TOTAL: {invoice.currency} {invoice.amount}</b>
            </div>
        </Col>
        <Col xs={12} sm={6}>
            <div id={styles.signature}>
                ______________________ {invoice.signature}
            </div>
        </Col>
        </Row>
        </Grid>
    </>


options = 
    urls: (props) ->
        orderId = props.match.params.orderId
        password = (new URLSearchParams(props.location.search)).get("password") || ""
        return
            invoice: "invoice/#{orderId}?password=#{password}"

export default withRouter(ConnectedComponent(Invoice, options))