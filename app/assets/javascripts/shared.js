$(document).ready(function() {
  $(".js-delete").click(function(){
    url = $('.js-delete-modal').data('url')
    $.ajax({
      url: url,
      type: 'DELETE',
      success: function(result) {
        window.location.href = result.location
      },
      error: function(result){
        alert(result.responseJSON.error)
      }
    });
  });



  $('.js-broker-new-form').ajaxForm({
    success: function(response){
    },
    error: function(response){
      $('.js-errors').append('<ul></ul>')
      errors = response.responseJSON.error
      for(var i = 0 ; i < errors.length ; i++){
        $('.js-errors > ul').append("<li>"+errors[i]+"</li>")
      }
    }
  })
});