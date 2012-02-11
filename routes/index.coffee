request = require 'request'
step    = require 'stepc'
twtr    = require 'express-twitter'
util    = require 'util'
twtruri = 'https://api.twitter.com/1/statuses/public_timeline.json?count=3&include_entities=true'

requestCollapse = (options, callback) ->
  request options, (error, response, body) -> 
    callback error, { response, body }

jsonResponseHandler = (err, obj, cb) ->
  return cb err if err
  return cb "Error #{obj.response.statusCode} #{obj.body} #{err}" if not obj.response.statusCode == 200
  cb err, JSON.parse obj.body

module.exports =
  index:  (req, res, next) ->
    message = if req.session.twitter
    then "Ahoy #{req.session.twitter.name}. <a href='/sessions/logout'>Logout</a>"
    else 'Logged out. <a href="/sessions/login">Login Now!</a>'
    res.send "<h3>express-twitter demo</h3><p>#{message}</p>"
  tweets: (req, res, next) ->
    step.async(
      () ->
        requestCollapse {uri: twtruri, headers: {'Accept' : 'application/json', 'Content-Type' : 'application/json'}}, this
      (err, obj) ->
        jsonResponseHandler err, obj, this
      (err, data) ->
        res.render 'index', {title: err} if err
        console.log data
        res.render 'index', {title: "Twitter Public Timeline", tweets: data}
    )
  hello: (req, res) ->
    res.send """Welcome #{req.session.twitter.name}.<hr/>
      <a href="/sessions/debug">debug</a>  <a href="/you">about you</a>
      <a href="/follow">follow @mahemoff</a> <a href="/sessions/logout">logout</a>"""
  goodbye: (req, res) ->
    res.send 'Our paths crossed but briefly.'
  you: (req, res) ->
    twtr.getSelf req, (err, you, response) ->
      res.send "Hello #{you.name}. Twitter says of you:<pre>#{util.inspect(you)}</pre>"
  timeline: (req, res) ->
    twtr.getMyTimeline req, (err, timeline, response) ->
      res.render 'index', {title: "Twitter Public Timeline", tweets: timeline}
    