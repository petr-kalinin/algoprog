import news from "../lib/news"
import newsItem from "../lib/newsItem"

export default allNews = () ->
    return news([
        newsItem("English version", String.raw"""
            English version is basically working, although not all texts has been translated yet.
        """)
    ])
