express = require 'express'
routes = require './routes'
user = require './routes/user'
entry = require './routes/entry'
http = require 'http'
path = require 'path'
mongoose = require 'mongoose'


mongoose.connect 'mongodb://localhost/nwikidb'
app = express();


app.configure () ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser 'fdsjhfjfeuwhjnfdsnayfibdovbnujdiaonfhuyeoahf' 
  app.use express.session()
  app.use app.router
  app.use require('less-middleware')({ src: __dirname + '/public' })
  app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', () ->
  app.use express.errorHandler()

###
Routes
###

# Defaults 
#app.get '/', routes.index
app.get '/users', user.list

# Entry
app.get '/', entry.index
app.post '/', entry.addEntry
app.get '/new', entry.newEntryForm
app.get '/:title', entry.findByTitle
app.get '/:title/edit', entry.editEntryForm

http.createServer(app).listen app.get('port'), () ->
  console.log "Express server listening on port " + app.get('port')
