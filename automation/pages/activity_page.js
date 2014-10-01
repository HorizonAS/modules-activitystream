module.exports = {
   selectors: {
    'activity': '.activitystream-item:nth-child(1) .activitycaption',
  },

  load: function () {
    return this.client
      .url('http://as.dev.nationalgeographic.com:9000/')
      .pause(5000)
      .url('http://as.dev.nationalgeographic.com:9000/')
      .pause(10000);
  },


  //Verify the actor link on activities redirects to the user profile page on mmdb
  verifyLinkToProfile: function() {
    var actorText = this.selectors.activity + ' .caption a:nth-child(1)';
    var profile = 'https://members-test3.nationalgeographic.com/731046415557/'
    
    return this.client
      .click(actorText)
      .waitForElementVisible('body', 3000)
      .assert.urlEquals(profile);
  },

  verifyLinkToObject: function (url) {
    var objectText = this.selectors.activity + ' .caption a:nth-child(2)';
    return this.client
      .click(objectText)
      .waitForElementVisible('body', 3000)
      .assert.urlEquals(url);

  },

  //Verify no item classes present when the module is empty
  verifyModuleIsEmpty: function() { 
    return this.client
      .assert.elementNotPresent(this.selectors.activity);
  },

  //Verify the content of the activity 
  verifyActivity: function (activity) {
    var actorText = this.selectors.activity + ' .caption a:nth-child(1)';
    var objectText = this.selectors.activity + ' .caption a:nth-child(2)';
    var siteText = this.selectors.activity + ' .caption a:nth-child(3)';
    var date = this.selectors.activity + ' .activitycaption-date';
    var icon = this.selectors.activity + ' .' + activity.action;
    var currentDate = new Date();
    var month = ['Jan','Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul' , 'Aug',
      'Sep', 'Oct', 'Nov' ,'Dec'];

    return this.client
      .assert.containsText(actorText, activity.actor)
      .assert.containsText(objectText, activity.object)
      .assert.containsText(siteText, activity.site)
      .assert.containsText(date, currentDate.getDate() + ' ' + month[currentDate.getMonth()])
      .assert.elementPresent(icon)
      //.pause(1000)
      //.click(objectText)
      //.waitForElementVisible('body', 3000)
      //.assert.urlEquals(activity.url);

  }

};

