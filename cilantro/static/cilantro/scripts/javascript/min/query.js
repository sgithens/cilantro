define(["jquery","underscore","backbone","serrano"],function($,_,Backbone,Serrano){return $(function(){return $("[data-toggle=detail]").each(function(){var details,toggle;return toggle=$(this),details=toggle.parent().siblings(".details"),toggle.on("click",function(){return details.is(":visible")?details.slideUp(200):details.slideDown(200)})})})})