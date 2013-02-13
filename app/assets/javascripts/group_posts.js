// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  $("a.like").on("click", function(e){
    e.preventDefault();
    var btn = $(this);
    var alert_container = null;
    if(btn.parents("tr").length > 0)
      alert_container = btn.parents("tr").first().find(".span6");
    else
      alert_container = btn.parents(".span12").first();
    
    alert_container.find(".alert").remove();
    $.post(btn.attr('href'), function(data, status){
      alert_container.prepend($("<span class='alert alert-info' >" + data['message'] + "</span>"))
      if(btn.hasClass("btn-primary")){
        btn.removeClass("btn-primary");
        btn.html("NVM")
        btn.attr('href', btn.attr('href').replace(/like/, 'unlike'))
      }else{
        btn.addClass("btn-primary")
        btn.html("1UP")
        btn.attr('href', btn.attr('href').replace(/unlike/, 'like'))
      }
    });
    return false;
  });
});