$(document).ready(function() {
  $('.js-btn-edit').click(function(){
    parent = $(this).closest('.js-note')
    parent.find('.js-edit-field').show();
    var noteId = parent.attr('data-note-id');
  })

  $('.js-btn-note-cancel').click(function(){
    parent = $(this).closest('.js-note')
    parent.find('.js-edit-field').hide();
  })

  $('.js-btn-note-update').click(function(){
    parent = $(this).closest('.js-note')
    var url = $(this).data('update-url')
    var message = $(this).closest('.js-edit-field').find('textarea').val()
    $.ajax({
      url: url,
      type: 'PATCH',
      data: {message: message },
      success: function(result) {
        parent.find('.js-edit-field').hide();
        parent.find('.js-comment').html(result.message)
        parent.find('.js-note-date').html(result.updated_at)
      },
      error: function(result){
        parent.append(
          `
                <div class="js-note-error" style="color: red; margin-top: 10px;">
                  ${result.responseJSON.error}
                </div>
              `
        );
        setTimeout(function(){
          $('.js-note-error').remove();
        }, 3000);
      }
    });
  })
});