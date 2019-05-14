$(document).ready(function() {
  $('.js-btn-edit').click(function(){
    parent = $(this).closest('.js-note')
    parent.find('.js-edit-field').show();
    parent.find('.js-comment').hide();
    var noteId = parent.attr('data-note-id');
  })

  $('.js-btn-note-cancel').click(function(){
    parent = $(this).closest('.js-note')
    parent.find('.js-edit-field').hide();
    parent.find('.js-comment').show();
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
        parent.find('.js-comment').show();
        parent.find('.js-note-date').html(result.updated_at)
      },
      error: function(result){
        alert(result.responseJSON.error);
      }
    });
  })
});
