$(document).ready(function(){

  var tweet_template = $('#test-template').html()
  
  var authcallback = function(data) {
    displayTweets();
  };

  var displayTweets = function() {
    $.ajax({
      url: "/timeline", 
      success: function(data) {
        var template = Handlebars.compile(tweet_template);
        var tweets = {tweets: data};
        $('.banner').text("Your Timeline");
        $('.details').html(template(tweets));
        $('.login').text("Logout")
        $('.login').click(function(){ window.location = "/logout"; });
        $('#remove-me').remove();
        window.a = undefined;
      } 
    });
  };

  if (window.a) displayTweets();


  $('.login').click(function(){
  	openEasyOAuthBox('twitter', authcallback)
  });
   
});
 
