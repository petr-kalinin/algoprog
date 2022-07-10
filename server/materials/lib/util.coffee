export ruen = (ru, en) ->
    (lbl) ->
        if lbl == "" then ru
        else if lbl == "!en" then en
        else throw "unknown label #{lbl}"