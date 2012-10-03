// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  $("#group_kind").on("change", function(){
    if($(this).val() == "location"){
      $(".location").slideDown('fast');
    }else{
      $("#group_place").val("");
      $(".location").slideUp('fast');
    }
    
    if($(this).val() == "game" || $(this).val() == "guild"){
      $(".game").slideDown('fast');
    }else{
      $("#group_game").val("");
      $(".game").slideUp('fast');
    }
  });
})