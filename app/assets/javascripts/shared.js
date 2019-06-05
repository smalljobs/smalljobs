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


  $('.js-new-form').ajaxForm({
    success: function(response, statusText, xhr,  form){
      window.location = window.location.href
    },
    error: function(response, statusText, xhr,  form) {
      $(form).find('.js-errors').html('')
      $(form).find('.js-errors').append('<ul></ul>')
      errors = response.responseJSON.error
      for (var i = 0; i < errors.length; i++) {
        $(form).find('.js-errors > ul').append("<li>" + errors[i] + "</li>")
      }
      buttons = $(form).find('.form-actions > input')
      for (var i = 0; i < buttons.length; i++) {
        $(buttons[i]).removeAttr('disabled');
      }
    }
  })

  $(document).on('click', '.js-modal-edit', function(){
    url = $(this).data('url')
    $.ajax({
      url: url,
      type: 'GET',
      success: function(result) {
        $('.js-edit-modal-body').append(result)
        $('#broker_edit_modal').modal('show')
      },
      error: function(result){
        alert(result.responseJSON.error)
      }
    });
  })
});