// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  $("#badge_level").on("change", function(e){
    var sel = $(e.target);
    $(".con-badge-info").addClass("hide");
    $("#badge_info_" + sel.val()).removeClass("hide");
  });
  
  $(".con-badge-info").addClass("hide");
  $("#badge_info_" + $("#badge_level").val()).removeClass("hide");
  $("#redeem").on("change", function(){
    var div = $(this).val();
    $("#code").addClass("hide");
    $("#purchase").addClass("hide");
    $("#" + div).removeClass("hide");
  });
});