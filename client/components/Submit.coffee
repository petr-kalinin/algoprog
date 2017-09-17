React = require('react')
moment = require('moment')

import Table from 'react-bootstrap/lib/Table'
import Tabs from 'react-bootstrap/lib/Tabs'
import Tab from 'react-bootstrap/lib/Tab'

export default Submit = (props) ->
    <Tabs defaultActiveKey={1} id="submitTabs">
        <Tab eventKey={1} title="Исходный код">
            <pre dangerouslySetInnerHTML={{__html: props.submit.source}}></pre>
        </Tab>
        <Tab eventKey={2} title="Комментарии">
            {
            res = []
            a = (el) -> res.push(el)
            for comment, index in (props.submit?.comments || [])
                a <pre key={index} dangerouslySetInnerHTML={{__html: comment}}></pre>
            res}
        </Tab>
        <Tab eventKey={3} title="Результаты">
            <h4>Вывод компилятора</h4>
            <pre dangerouslySetInnerHTML={{__html: props.submit.results?.compiler_output}}></pre>
            <Table striped bordered condensed hover responsive>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Результат</th>
                        <th>Время</th>
                        <th>Память</th>
                    </tr>
                </thead>
                <tbody>
                    {
                    res = []
                    a = (el) -> res.push(el)
                    for index, result of (props.submit.results?.tests || [])
                        a <tr key={index}>
                            <td>{index}</td>
                            <td>{result.string_status}</td>
                            <td>{result.time/1000}</td>
                            <td>{result.max_memory_used}</td>
                        </tr>
                    res}
                </tbody>
            </Table>
        </Tab>
    </Tabs>
