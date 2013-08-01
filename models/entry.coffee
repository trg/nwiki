mongoose = require 'mongoose'
Schema = mongoose.Schema

EntrySchema = new Schema {
    title:
        type: String
        index: true
    body: String
    timestamp:
        type: Date
        default: Date.now
}

module.exports = mongoose.model 'Entry', EntrySchema