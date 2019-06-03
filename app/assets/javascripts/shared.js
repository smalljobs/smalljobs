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
});