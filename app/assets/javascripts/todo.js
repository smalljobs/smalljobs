$(document).ready(function() {
  $(document).on('click', '.js-postpone', function(){
    tr = $(this).closest('tr')
    url = $(this).data('url')
    todo_type = $(this).data('todo-type')
    $.ajax({
      url: url,
      type: 'PATCH',
      success: function(result) {
        if(todo_type == 'postponed'){
          tr_last = tr.clone()
          tr_last.find('span').data('todo-type', 'current')
          tr_last.find('td').last().remove()
          $('.js-todo-current').find('tbody').prepend(tr_last)
          $('.js-todo-tabs > li > a[href="#todo_current"] > .sj-text-red').html($('#todo_current').find('tbody').find('tr').length)
          $('.js-todo-tabs > li > a[href="#todo_postponed"] > .sj-text-red').html($('#todo_postponed').find('tbody').find('tr').length-1)
        } else if(todo_type == 'current'){
          tr_last = tr.clone()
          tr_last.find('span').data('todo-type', 'postponed')
          tr_last.append("<td>"+result.postponed+"</td>śś")
          $('.js-todo-postponed').find('tbody').prepend(tr_last)
          $('.js-todo-tabs > li > a[href="#todo_postponed"] > .sj-text-red').html($('#todo_postponed').find('tbody').find('tr').length)
          $('.js-todo-tabs > li > a[href="#todo_current"] > .sj-text-red').html($('#todo_current').find('tbody').find('tr').length-1)
        }
        $('.js-postpone-msg').text(result.message)
        $('.js-postpone-msg').show();
        setTimeout(function(){$('.js-postpone-msg').hide()}, 3000)
        tr.remove()
      },
      error: function(result){
        alert(result.responseJSON.error);
      }
    });
  })

  window.setTimeout(
    function(){
      if($('.js-active-tab').find('.active > a').attr('href') != '#todo_current') {
        $('.js-todo-tabs').hide()
      }else{
        $('.js-todo-tabs').show()
      }
  },0)

  $('.js-active-tab').on('click', function(){
    window.setTimeout(
      function(){
        if($('.js-active-tab').find('.active > a').attr('href') != '#todo_current') {
          $('.js-todo-tabs').hide()
        }else{
          $('.js-todo-tabs').show()
        }
      },0)
  })
});
