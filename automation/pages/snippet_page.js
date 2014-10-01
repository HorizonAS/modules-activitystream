module.exports = {
   selectors: {
    'followIcon': '.activitysnippet:nth-child(8) span a i',
    'favoriteIcon': '.activitysnippet:nth-child(9) span a i',
    'watchIcon': '.activitysnippet:nth-child(10) span a i',
  },

  load: function () {
    return this.client
      .url('http://as.dev.nationalgeographic.com:9001/')
      .waitForElementVisible('body', 3000)
      .setCookie({
        name     : "mmdbsessionid",
        value    : "v2zoa2txubjc5ml9ua6c6toh0gktd807",
        path     : "/", 
        domain   : ".nationalgeographic.com",
        secure   : false
      })
      .pause(2000);
  },

  clickSnippets: function (){
    var snippets = [this.selectors.followIcon, this.selectors.favoriteIcon, this.selectors.watchIcon];
    
    for (var i = 0; i < snippets.length; i++) {
      this.client
      .click(snippets[i])
      .pause(2000)
    };
    return this.client
    .pause(2000)

  },

  clickFollowSnippet : function(){
    return this.client
      .click(this.selectors.followIcon)
      .pause(5000)
  },

  clickFavoriteSnippet : function(){
    return this.client
      .click(this.selectors.favoriteIcon)
      .pause(5000)
  },

  clickWatchSnippet : function(){
    return this.client
      .click(this.selectors.watchIcon)
      .pause(5000)
  }

};

