mongoose = require('mongoose')

tablesSchema = new mongoose.Schema
    _id: String
    name: String
    tables: [String]
    problems: [String]
    parent: String
    order: Number
        
tablesSchema.methods.upsert = () ->
    Table.update({_id: @_id}, this, {upsert: true}).exec()

Table = mongoose.model('Tables', tablesSchema);

export default Table
