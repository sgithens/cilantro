// Generated by CoffeeScript 1.3.3
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['use!underscore', 'use!backbone'], function(_, Backbone) {
  var DataConcept, DataConcepts, DataContext, DataContexts, DataField, DataFields;
  DataField = (function(_super) {

    __extends(DataField, _super);

    function DataField() {
      return DataField.__super__.constructor.apply(this, arguments);
    }

    return DataField;

  })(Backbone.Model);
  DataFields = (function(_super) {

    __extends(DataFields, _super);

    function DataFields() {
      return DataFields.__super__.constructor.apply(this, arguments);
    }

    DataFields.prototype.model = DataField;

    return DataFields;

  })(Backbone.Collection);
  DataConcept = (function(_super) {

    __extends(DataConcept, _super);

    function DataConcept() {
      return DataConcept.__super__.constructor.apply(this, arguments);
    }

    return DataConcept;

  })(Backbone.Model);
  DataConcepts = (function(_super) {

    __extends(DataConcepts, _super);

    function DataConcepts() {
      return DataConcepts.__super__.constructor.apply(this, arguments);
    }

    DataConcepts.prototype.model = DataConcept;

    return DataConcepts;

  })(Backbone.Collection);
  DataContext = (function(_super) {

    __extends(DataContext, _super);

    function DataContext() {
      return DataContext.__super__.constructor.apply(this, arguments);
    }

    return DataContext;

  })(Backbone.Model);
  DataContexts = (function(_super) {

    __extends(DataContexts, _super);

    function DataContexts() {
      return DataContexts.__super__.constructor.apply(this, arguments);
    }

    DataContexts.prototype.model = DataContext;

    return DataContexts;

  })(Backbone.Collection);
  return {
    DataFields: DataFields,
    DataConcepts: DataConcepts,
    DataContexts: DataContexts
  };
});
