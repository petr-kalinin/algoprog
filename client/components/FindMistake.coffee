import Editor from '@monaco-editor/react';
import React, { useRef, useState } from "react";
import { Button, ListGroup, ListGroupItem } from 'react-bootstrap'
import {Link} from 'react-router-dom'

import Loader from '../components/Loader'

import ConnectedComponent from '../lib/ConnectedComponent'
import {DISTANCE_THRESHOLD, distance} from '../lib/findMistake'
import withMyUser from '../lib/withMyUser'

import styles from './FindMistake.css'

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

    options = 
        autoClosingBrackets: "never"
        autoClosingOvertype: "never" 
        autoClosingQuotes: "never"
        scrollBeyondLastLine: false
        minimap: {enabled: false}

    <>
        <div class={styles.top}>
            <div class={styles.left}><Button onClick={resetEditor}>Сбросить правки</Button></div>
            <div class={styles.right}>Исправлений: {currentDistance}</div>
        </div>
        <Editor height="600px" language="python" value={props.findMistake?.source} loading={<Loader />} options={options} className={styles.editor} editorDidMount={handleEditorDidMount}/>
    </>


export default FindMistake
