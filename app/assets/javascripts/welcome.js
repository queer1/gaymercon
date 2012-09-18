$(function(){
  if($("#payment-form").length > 0){
    $("#payment-amount").on("change", function(){
      if($(this).val() == "other"){
        $(".amount-other").show();
      }else {
        $(".amount-other").val("");
        $(".amount-other").hide();
      }
    });
    
    $("#payment-form").on("submit", function(event) {
      if($("#payment-form").find("#stripe-token").length > 0)
        return true;
      
      // disable the submit button to prevent repeated clicks
      $('.submit-button').attr("disabled", "disabled");

      Stripe.createToken({
          number: $('.card-number').val(),
          cvc: $('.card-cvc').val(),
          exp_month: $('.card-expiry-month').val(),
          exp_year: $('.card-expiry-year').val()
      }, function(status, response){
        var form = $("#payment-form");
        if (response.error) {
          $("#payment-form").before("<div class='alert'>" + response.error.message + "</div>")
          $(".submit-button").removeAttr("disabled");
        } else {
          var token = response['id'];
          form.append("<input type='hidden' name='token' id='stripe-token' value='" + token + "'/>");
          form.get(0).submit();
        }
      });

      // prevent the form from submitting with the default action
      return false;
    });
  }
})