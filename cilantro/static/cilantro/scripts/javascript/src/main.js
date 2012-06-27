// Generated by CoffeeScript 1.3.3

define(['environ', 'jquery', 'router', 'session', 'models/charts', 'models/datafields', 'models/dataconcepts', 'models/datacontexts', 'models/dataviews'], function(environ, $) {
  return require(['routes/app', 'routes/workspace', 'routes/discover', 'routes/composite', 'routes/analyze', 'routes/review'], function(AppArea, WorkspaceArea, DiscoverArea, CompositeArea, AnalysisArea, ReviewArea) {
    App.register(false, 'app', new AppArea);
    App.register('', 'workspace', new WorkspaceArea);
    App.register('discover/', 'discover', new DiscoverArea);
    App.register('discover/composite/', 'composite', new CompositeArea);
    App.register('analyze/', 'analyze', new AnalysisArea);
    App.register('review/', 'review', new ReviewArea);
    Backbone.history.start({
      pushState: true,
      root: environ.SCRIPT_NAME || '/'
    });
    App.preferences.load();
    return $(function() {
      $('.panel').panel();
      $('[data-toggle*=panel]').each(function() {
        var toggle;
        return (toggle = $(this)).on('click', function() {
          var panel;
          if (toggle.data('target')) {
            panel = $(toggle.data('target'));
          } else {
            panel = toggle.parent();
          }
          return panel.panel('toggle');
        });
      });
      return $('body').on('click', '[data-route]', function(event) {
        event.preventDefault();
        return App.router.navigate(this.pathname, {
          trigger: true
        });
      });
    });
  });
});
