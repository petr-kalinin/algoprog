React = require('react')

import { Helmet } from "react-helmet";

import {LangRaw} from '../lang/lang'

import stripLabel from '../lib/stripLabel'
import withLang from '../lib/withLang'
import withTheme from '../lib/withTheme'

import TableRow from './TableRow'
import globalStyles from './global.css'
import styles from './Table.css'

getHeader = (results) ->
    if not results
        return undefined
    res = []
    for table in results
        t =
            _id: table._id
            results: []
        for subtable in table.results
            t.results.push
                _id: subtable._id
                name: subtable.name
                colspan: subtable.results.length
        res.push(t)
    return res

Text = withLang (props) ->
    LANG = (id) -> LangRaw(id, props.lang)
    if props.levels == "main" or  props.levels == "main!en"
        <div>
            <Helmet>
                <title>{LANG("main_table")}</title>
            </Helmet>
            <h1>{LANG("main_table")}</h1>
            {LANG("main_table_notes")}
        </div>
    else
        <div>
            <Helmet>
                <title>{LANG("table_header")(props.levels)}</title>
            </Helmet>
            <h1>{LANG("table_header")(props.levels)}</h1>
            <p>{LANG("colors")}:{" "}
                <span className={ if props.theme == "dark" then globalStyles.darkac else globalStyles.ac + " " + styles.example}>{LANG("accepted")}</span>{" "}
                <span className={globalStyles.ig + " " + styles.example}>{LANG("ignored")}</span>{" "}
                <span className={ if props.theme == "dark" then globalStyles.darkok else globalStyles.ok + " " + styles.example}>OK</span>{" "}
                <span className={globalStyles.wa + " " + styles.example}>{LANG("partial_solution_etc")}</span>
            </p>
            {LANG("table_notes")}
        </div>

Text = withTheme(Text)

export default Table = (props) ->
    if not props.data?.length
        return <table className={globalStyles.mainTable}/>

    header = getHeader(props.data[0].results)
    levels = (r._id for r in header).map(stripLabel).join(", ")

    <div>
        {props.headerText && <Text levels={levels} /> }
        <div className={globalStyles.mainTable_div}>
            <table className={globalStyles.mainTable}>
                <tbody>
                    <TableRow details={props.details} header={true} results={header}/>
                    {
                    res = []
                    a = (el) -> res.push(el)
                    for result in props.data
                        a <TableRow details={props.details} user={result.user} results={result.results} key={result.user._id}/>
                    res}
                </tbody>
            </table>
        </div>
    </div>
