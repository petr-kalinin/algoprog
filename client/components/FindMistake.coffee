import Editor from '@monaco-editor/react';
import React, { useRef, useState } from "react";
import { Button, ListGroup, ListGroupItem } from 'react-bootstrap'
import {Link} from 'react-router-dom'

import Loader from '../components/Loader'

import ConnectedComponent from '../lib/ConnectedComponent'
import {DISTANCE_THRESHOLD, distance} from '../lib/findMistake'
import withMyUser from '../lib/withMyUser'

import SubmitList from './SubmitList'

import styles from './FindMistake.css'

LANGUAGE_TO_MONACO_STYLE =
    "Python": "python",
    "Pascal": "pascal",
    "C++": "cpp",
    " C": "cpp",  # space important
    "Delphi": "pascal",
    "Java": "java"
    "PHP": "php",
    "Perl": "perl",
    "C#": "csharp",
    "Ruby": "ruby",
    
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
        <h1><Link to="/material/#{props.findMistake.problem}">{props.findMistake.fullProblem.name}</Link></h1>
        <div className={styles.top}>
            <div className={styles.left}><Button onClick={resetEditor}>Сбросить правки</Button></div>
            <div className={styles.right + if tooMuchChanges then " text-danger" else ""}>Исправлений: {currentDistance} (можно {maxSubmits})</div>
        </div>
        <Editor height="600px" language={getLanguage(props.findMistake?.language)} value={props.findMistake?.source} loading={<Loader />} options={options} className={styles.editor} editorDidMount={handleEditorDidMount}/>
        <SubmitList material={props.material} noFile={true} noBestSubmits={true} getSource={getValue} canSubmit={!tooMuchChanges} findMistake={props.findMistake._id} startLanguage={props.findMistake?.language}/>
    </>

options = 
    urls: (props) ->
        "material": "material/#{props.findMistake.problem}"

export default ConnectedComponent(FindMistake, options)
