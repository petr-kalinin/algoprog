export requestPermission = () ->
    window.Notification?.requestPermission();

export notify = (tag, title, body, url) ->
    if not window.Notification
        return
    if window.Notification.permission != "granted"
        return
    notification = new window.Notification(title, {tag, body})
    notification.onclick = (event) ->
        window.goto(url)()
