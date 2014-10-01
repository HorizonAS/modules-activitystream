var path = require('path');

module.exports = {
  tags: ['sanity'],

  'Testing the module': function (client) {
    require('nightwatch-pages')(client, path.resolve(__dirname, '..', 'pages'));


    function Activity(action, actor, object, site, url) {
      this.action = action;
      this.actor = actor;
      this.object = object;
      this.site = site;
      this.url = url;
    };

    followActivity = new Activity('FOLLOWED', 'Leandro Guelerman', 'Matias Montenegro', 'mmdb',
       'https://members-test3.nationalgeographic.com/174834656615/');
    
    favoriteActivity = new Activity('FAVORITED', 'Leandro Guelerman', 'Kayapo Courage', 'ngm',
       'https://members-test3.nationalgeographic.com/174834656615/');

    watchActivity = new Activity('WATCHED', 'Leandro Guelerman', 'Kayapo Courage', 'ngm',
       'https://members-test3.nationalgeographic.com/174834656615/');

    client
      .page.snippet_page.load()
      .page.snippet_page.clickFollowSnippet()
      .page.activity_page.load()
      .page.activity_page.verifyActivity(followActivity)
      .page.activity_page.verifyLinkToObject(followActivity.url)
      .page.activity_page.load()
      .page.activity_page.verifyLinkToProfile()
      .page.snippet_page.load()
      .page.snippet_page.clickFavoriteSnippet() 
      .page.activity_page.load()
      .page.activity_page.verifyActivity(favoriteActivity)
      .page.activity_page.verifyLinkToProfile()
      .page.snippet_page.load()
      .page.snippet_page.clickWatchSnippet() 
      .page.activity_page.load()
      .page.activity_page.verifyActivity(watchActivity)
      .page.activity_page.verifyLinkToProfile()
      .page.snippet_page.load()
      .page.snippet_page.clickSnippets()
      .page.activity_page.load()
      .page.activity_page.verifyModuleIsEmpty()
      //.saveScreenshot('./results/screenshots/screen2.png')
      .end();
  }
};
