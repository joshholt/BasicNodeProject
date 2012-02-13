express = require 'express'
stylus  = require 'stylus'
assets  = require 'connect-assets'
routes	= require './routes'
auth		= require 'easy-oauth'
port 		= process.env.PORT or 3000
module.exports = app = express.createServer()

app.use assets()
app.set 'view engine', 'jade'

app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session({secret: 'randomstuffherethatstryingtobeasecret12@@124'})
app.use express.static "#{__dirname}/public"
app.use auth require "./lib/keys_file"
app.use app.router

app.get '/', routes.index
app.get '/timeline', routes.timeline

app.listen port, -> console.log "Listening @ http://0.0.0.0:#{port}"