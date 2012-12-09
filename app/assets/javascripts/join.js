$(function(){
  $("#badge_level").on("change", function(e){
    var sel = $(e.target);
    $(".con-badge-info").hide();
    $("#badge_info_" + sel.val()).show();
  });
  
  $(".con-badge-info").hide();
  $("#badge_info_" + $("#badge_level").val()).show();
  
});