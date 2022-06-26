import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("English news test", String.raw"""
            English news
        """)
    ])
