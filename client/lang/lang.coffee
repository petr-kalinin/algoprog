_LANG = 
    news_url:
        "ru": "/material/news"
        "en": "/material/news!en"
    news:
        "ru": "Новости"
        "en": "News"
    recent_comments:
        "ru": "Последние комментарии"
        "en": "Recent comments"
    all_comments:
        "ru": "Все комментарии"
        "en": "All comments"

export default LANG = (id, lang) ->
    _LANG[id]?[lang] || throw "Unknown lang #{id} #{lang}"
