$(function(){
  $(".user-role select").on("change", function(e){
    $(this).parents('form').first().submit();
  });
})