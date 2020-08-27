import Editor from '@monaco-editor/react';
import React, { useRef, useState } from "react";

import Loader from '../components/Loader'

import styles from './Editor.css'

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

export default AdaptedEditor = (props) ->
    options = 
        autoClosingBrackets: "never"
        autoClosingOvertype: "never" 
        autoClosingQuotes: "never"
        scrollBeyondLastLine: false
        minimap: {enabled: false}
    <Editor height="600px" language={getLanguage(props.language)} value={props.value} loading={<Loader />} options={options} className={styles.editor} editorDidMount={props.editorDidMount}/>
