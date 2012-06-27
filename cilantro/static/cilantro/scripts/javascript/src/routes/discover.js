// Generated by CoffeeScript 1.3.3
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['environ', 'jquery', 'backbone', 'views/queryviews'], function(environ, $, Backbone) {
  var DiscoverArea;
  return DiscoverArea = (function(_super) {

    __extends(DiscoverArea, _super);

    function DiscoverArea() {
      return DiscoverArea.__super__.constructor.apply(this, arguments);
    }

    DiscoverArea.prototype.id = 'discover-area';

    DiscoverArea.prototype.initialize = function() {
      return this.$el.hide().css('margin-left', '250px').appendTo('#main-area .inner');
    };

    DiscoverArea.prototype.load = function() {
      this.$el.fadeIn();
      return App.QueryViewsPanel.$el.panel('open');
    };

    DiscoverArea.prototype.unload = function() {
      this.$el.hide();
      return App.QueryViewsPanel.$el.panel('close');
    };

    return DiscoverArea;

  })(Backbone.View);
});
