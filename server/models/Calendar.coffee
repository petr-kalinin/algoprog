mongoose = require('mongoose')

import logger from '../log'

calendarSchema = new mongoose.Schema
    _id: String
    byDay: mongoose.Schema.Types.Mixed

calendarSchema.methods.upsert = () ->
    @update(this, {upsert: true, overwrite: true})

Calendar = mongoose.model('Calendar', calendarSchema)

export default Calendar
