// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  $("#badge_level").on("change", function(e){
    var sel = $(e.target);
    $(".badge-info").hide();
    $("#badge_info_" + sel.val()).show();
  });
  
  $(".badge-info").hide();
  $("#badge_info_" + $("#badge_level").val()).show();
});