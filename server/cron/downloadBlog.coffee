feedparser = require('feedparser-promised')

import BlogPost from "../models/BlogPost"
import logger from '../log'
import awaitAll from '../../client/lib/awaitAll'

URL = "http://blog.algoprog.ru/feed.xml"

download = () ->
    posts = await feedparser.parse(URL)
    realIds = {}
    promises = []

    for post in posts
        realIds[post.guid] = true
        post = new BlogPost
            _id: post.guid
            title: post.title
            link: post.link
            date: post.pubdate
        promises.push(post.upsert())

    for oldPost in await BlogPost.find({})
        if not realIds[oldPost._id]
            promises.push(oldPost.remove())

    await awaitAll(promises)


running = false

wrapRunning = (callable) ->
    () ->
        if running
            logger.info "Already running downloadBlog"
            return
        try
            running = true
            await callable()
        finally
            running = false

export run = wrapRunning () ->
    logger.info "Downloading blog posts"
    await download()
    logger.info "Done downloading blog posts"
