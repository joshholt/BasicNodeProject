express = require 'express'
stylus  = require 'stylus'
assets  = require 'connect-assets'
twtr		= require 'express-twitter'
routes	= require './routes'
port 		= process.env.PORT or 3000
module.exports = app = express.createServer()

app.use assets()
app.set 'view engine', 'jade'

app.use express.cookieParser()
app.use express.session
	secret: 'randomstuffherethatstryingtobeasecret12@@124'

app.use twtr.middleware
	consumerKey: "HCySyKZuczcX6RF371m99A" # Use your own key from Twitter's dev dashboard
	consumerSecret: "Khaaa34HVElqbzeKdPH5X3wWwzdUPX9VYjPIZTOwy1E" # ditto
	baseURL: 'http://localhost:3000' # Your app's URL, used for Twitter callback
	logging: true # If true, uses winston to log.
	afterLogin: '/timeline' # Page user returns to after twitter.com login
	afterLogout: '/goodbye' # Page user returns to after twitter.com logout

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.static "#{__dirname}/public"

app.get '/', routes.index
app.get '/hello', routes.hello
app.get '/goodbye', routes.goodbye
app.get '/you', routes.you
app.get '/timeline', routes.timeline

#app.listen port, -> console.log "Listening @ http://0.0.0.0:#{port}"