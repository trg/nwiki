Entry = require '../models/entry'
entryMapReduce = require '../mapreduce/entry'
mongoose = require 'mongoose'
underscore = require 'underscore'

findLatestEntryByTitle = (title, callback) ->
  Entry.findOne({title: title})
       .where('title').equals(title)
       .sort('-timestamp')
  .exec callback

exports.index = (req, res) ->
  o =
    map: ->
      key = @title
      values = 
        this
      emit(key, values)
    reduce: (title, entriesWithTitle) ->
      latestEntry = entriesWithTitle[0]
      for entry in entriesWithTitle
        if entry.timestamp > latestEntry.timestamp
          latestEntry = entry
      return latestEntry

  Entry.mapReduce o, (err, results) ->
    entries = []
    entries.push(result.value) for result in results
    entries = underscore.sortBy( entries, 'timestamp' ).reverse()
    res.render 'entry/index', {title: "All", entries: entries}

  #Entry.collection.distinct 'title', (err, titles) ->
  #  unless err
  #    res.render 'entry/index', {title: "All", titles: titles}

exports.findByTitle = (req, res) ->
  title = req.params.title
  findLatestEntryByTitle title, (err, entry) ->
    unless err
      res.render 'entry/show', { title: entry.title, entry: entry }

exports.addEntry = (req, res) ->
  entry = req.body
  console.log 'Adding entry: ' + JSON.stringify entry
  new Entry(entry).save (err, entry) ->
    unless err
      res.redirect '/' + entry.title

exports.newEntryForm = (req, res) ->
  res.render 'entry/edit', { title: 'New Entry', entry: null }

exports.editEntryForm = (req, res) ->
  findLatestEntryByTitle req.params.title, (err, entry) ->
    unless err
      res.render 'entry/edit', { title: entry.title, entry: entry }