keys = require '../lib/keys_file'
tkey = keys.twitter.consumerkey
tsec = keys.twitter.consumersecret
twtr = require('../lib/twitter-js')(tkey, tsec)


module.exports =
  index:  (req, res, next) ->
    req.authenticate ['oauth'], (err, authenticated) ->
      res.render 'index', {title: "Express Coffee Talk", isAuthenticated: authenticated}
  timeline: (req, res) ->
    auth = req.getAuthDetails()

    options =
      token:
        oauth_token_secret: auth.twitter_oauth_token_secret
        oauth_token:        auth.twitter_oauth_token
    
    twtr.apiCall 'GET', "/statuses/home_timeline.json?include_entities=true", options, (err, result) ->
      res.send result
    