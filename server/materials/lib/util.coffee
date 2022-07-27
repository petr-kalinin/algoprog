export ruen = (ru, en) ->
    (lbl) ->
        if lbl == "" then ru
        else if lbl == "!en" then en
        else throw "unknown label #{lbl}"

export levelDtitle = (num) ->
    (label) ->
        if label == "" then "Дополнительные задачи на разные темы — #{num}"
        else if label == "!en" then "Additional miscellaneous problems — #{num}"
        else throw "unknown label #{label}"

export levelDmessage = ruen("<p>Чтобы перейти на следующий уровень, надо решить <b>минимум треть задач</b>. Когда вы их решите, я рекомендую вам переходить на следующий уровень, чтобы не откладывать изучение новой теории. К оставшимся задачам этого уровня возвращайтесь позже время от времени и постарайтесь со временем все-таки дорешать почти все их до конца.</p>",
        "<p>To advance to next level, you need to solve <b>at least one third of the problems</b>. When you solve them, I recommend that you move to the next level, so as not to delay the study of new theory. Return to the remaining tasks of this level later from time to time and try to gradually solve almost all of them.</p>")

export levelDid = (num) ->
    (lbl) -> 
        if lbl == "" then "#{num}Г"
        else if lbl == "!en" then "#{num}D"    
