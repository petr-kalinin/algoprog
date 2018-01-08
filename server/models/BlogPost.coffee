mongoose = require('mongoose')

import logger from '../log'

blogPostSchema = new mongoose.Schema
    _id: String
    title: String
    link: String
    date: Date

blogPostSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a material"

blogPostSchema.statics.findLast = (limit, time) ->
    BlogPost.find({date: {$gt: new Date(new Date() - time)}}) \
        .sort({date: -1}).limit(limit)


blogPostSchema.index({ date : -1 })

BlogPost = mongoose.model('BlogPosts', blogPostSchema);

export default BlogPost
