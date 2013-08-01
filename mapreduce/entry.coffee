require '../models/entry'

exports.indexMap = ->
    emit 'timestamp'

exports.indexReduce = (prev, doc) ->
    if (doc.timestamp > prev.timestamp)
        prev = doc

