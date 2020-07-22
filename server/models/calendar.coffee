mongoose = require('mongoose')

import logger from '../log'

calendarSchema = new mongoose.Schema
    _id: String
    user: String
    byDay: {submits: mongoose.Schema.Types.Mixed}

calendarSchema.methods.upsert = () ->
    @update(this, {upsert: true, overwrite: true})

calendarSchema.statics.findByUser = (userId) ->
    return Calendar.find
        user: userId

calendarSchema.index
    user: 1
 
Calendar = mongoose.model('Calendar', calendarSchema)

export default Calendar
