var __bind=function(fn,me){return function(){return fn.apply(me,arguments)}},__hasProp={}.hasOwnProperty,__extends=function(child,parent){function ctor(){this.constructor=child}for(var key in parent)__hasProp.call(parent,key)&&(child[key]=parent[key]);return ctor.prototype=parent.prototype,child.prototype=new ctor,child.__super__=parent.prototype,child};define(["environ","mediator","jquery","underscore","backbone","views/charts"],function(environ,mediator,$,_,Backbone,Charts){var AnalysisArea,addChartButton;return addChartButton=_.template('<button class=btn title="Add Chart"><i class=icon-signal alt="Add Chart"></i></button>'),AnalysisArea=function(_super){function AnalysisArea(){return this.updateCharts=__bind(this.updateCharts,this),AnalysisArea.__super__.constructor.apply(this,arguments)}return __extends(AnalysisArea,_super),AnalysisArea.prototype.id="analysis-area",AnalysisArea.prototype.deferred={updateCharts:!0},AnalysisArea.prototype.initialize=function(){var $addChart,_this=this;return this.charts=[],this.$toolbar=$("<ul>").addClass("nav pull-right").hide().appendTo("#subnav .container-fluid"),this.$el.hide().appendTo("#main-area .inner").addClass("row-fluid").sortable({items:"> .area-container",handle:".heading",update:function(event,ui){var charts,idx,view,_i,_len,_ref,_results;charts=_this.$el.children(".chart-container"),_ref=_this.charts,_results=[];for(_i=0,_len=_ref.length;_i<_len;_i++)view=_ref[_i],idx=charts.index(view.el),_results.push(view.model.set({order:idx}));return _results}}),$addChart=$(addChartButton()).on("click",function(event){return _this.addChart()}),this.$toolbar.append($addChart),this.defer(function(){var model,_i,_len,_ref,_results;_ref=App.Distribution.models,_results=[];for(_i=0,_len=_ref.length;_i<_len;_i++)model=_ref[_i],_results.push(_this.addChart(model));return _results}),mediator.subscribe("datacontext/change",this.updateCharts)},AnalysisArea.prototype.updateCharts=function(){var view,_i,_len,_ref;_ref=this.charts;for(_i=0,_len=_ref.length;_i<_len;_i++)view=_ref[_i],view.updateChart()},AnalysisArea.prototype.load=function(){return this.$el.fadeIn(100),this.$toolbar.fadeIn(100)},AnalysisArea.prototype.unload=function(){return this.$el.hide(),this.$toolbar.hide()},AnalysisArea.prototype.addChart=function(attrs){var model,view;return!attrs instanceof App.Distribution.model?model=attrs:model=App.Distribution.create(attrs),view=new Charts.Distribution({model:model,collection:App.DataField}),this.charts.push(view),this.$el.append(view.$el),view.updateChart()},AnalysisArea}(Backbone.View),App.register("analyze/","analyze",new AnalysisArea)})