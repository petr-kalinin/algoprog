import React, { useRef, useState } from "react";
import { Button, ListGroup, ListGroupItem } from 'react-bootstrap'
import {Link} from 'react-router-dom'

import Loader from '../components/Loader'

import ConnectedComponent from '../lib/ConnectedComponent'
import {DISTANCE_THRESHOLD, distance} from '../lib/findMistake'
import withMyUser from '../lib/withMyUser'

import SubmitList from './SubmitList'

import styles from './FindMistake.css'

   
getLanguage = (lang) ->
    for l, style of LANGUAGE_TO_MONACO_STYLE
        if lang && lang.includes(l)
            return style
    return undefined

FindMistake = (props) ->
    [currentDistance, setCurrentDistance] = useState(0);
    editorRef = useRef()

    handleEditorDidMount = (_, editor) ->
        editorRef.current = editor;
        setCurrentDistance(distance(props.findMistake?.source, editor.getValue()))
        editorRef.current.onDidChangeModelContent () -> 
            text = editorRef.current.getValue()
            setCurrentDistance(distance(props.findMistake?.source, text))

    resetEditor = () ->
        editorRef.current.setValue(props.findMistake?.source)

    getValue = () ->
        editorRef.current.getValue()

    options = 
        autoClosingBrackets: "never"
        autoClosingOvertype: "never" 
        autoClosingQuotes: "never"
        scrollBeyondLastLine: false
        minimap: {enabled: false}

    maxSubmits = Math.floor(DISTANCE_THRESHOLD * 1.5)
    tooMuchChanges = currentDistance > maxSubmits

    <>
        <h1>Найди ошибку: <Link to="/material/#{props.findMistake.problem}">{props.findMistake.fullProblem.name}</Link></h1>
        <p><Link to="/material/about_find_mistake">О поиске ошибок</Link></p>
        <div className={styles.top}>
            <div className={styles.left}><Button onClick={resetEditor}>Сбросить правки</Button></div>
            <div className={styles.right + if tooMuchChanges then " text-danger" else ""}>Исправлений: {currentDistance} (можно {maxSubmits})</div>
        </div>
        <SubmitList material={props.material} 
            noFile={true}
            noBestSubmits={true}
            canSubmit={!tooMuchChanges}
            findMistake={props.findMistake._id}
            startLanguage={props.findMistake?.language}
            editorOn={true}
            editorDidMount={handleEditorDidMount}
            defaultSource={props.findMistake?.source}/>
    </>

options = 
    urls: (props) ->
        "material": "material/#{props.findMistake.problem}"

export default ConnectedComponent(FindMistake, options)
