// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function(){
  $("#group_kind").on("change", function(){
    if($(this).val() == "location"){
      $(".location").removeClass('hide');
      $(".location").slideDown('fast');
    }else{
      $("#group_place").val("");
      $(".location").slideUp('fast', function(){ $(".location").addClass('hide'); });
    }
    
    if($(this).val() == "game" || $(this).val() == "guild"){
      $(".game").slideDown('fast');
    }else{
      $("#group_game").val("");
      $(".game").slideUp('fast');
    }
  });
  
  $("#add_user").each(function(elem){
    var input = $(this);
    var klass = "user";
    input.typeahead({
      source: function(query, process){
        $.get('/typeahead', {q: query, kind: klass}, function(data){ 
          input.data('choices', data);
          var choices = [];
          $.each(data, function(key, val){ choices.push(key) })
          process(choices);
        });
      },
      items: 4,
      minLength: 3,
      updater: function(item){ 
        $("#add_users").append("<li>" + item + "<input type='hidden' name='add_users[]' value='" + input.data('choices')[item] + "' />  &nbsp;&nbsp;<a class='delete_user danger' href='#'>&times;</a></li>");
        return "";
      }
    });
  });
  
  $("#add_users").on("click", ".delete_user", function(){
    $(this).parents("li").fadeOut(function(){ $(this).remove(); })
  });
  
})