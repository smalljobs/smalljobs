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
        } else if(todo_type == 'current'){
          tr_last = tr.clone()
          tr_last.find('span').data('todo-type', 'postponed')
          tr_last.append("<td>"+result.postponed+"</td>")
          $('.js-todo-postponed').find('tbody').prepend(tr_last)
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
      if($('.js-active-tab').find('.active > a').attr('href') == '#todos') {
        which_todo = $('.js-todo-tabs').find('.active > a').attr('href')
        $(which_todo).show()
        if(which_todo == '#todo_current'){
          $('#todo_postponed').hide()
        }else{
          $('#todo_current').hide()
        }
      }
  },0)

  $('.js-active-tab').on('click', function(){
    window.setTimeout(
      function(){
        if($('.js-active-tab').find('.active > a').attr('href') == '#todos') {
          which_todo = $('.js-todo-tabs').find('.active > a').attr('href')
          $(which_todo).show()
          if(which_todo == '#todo_current'){
            $('#todo_postponed').hide()
          }else{
            $('#todo_current').hide()
          }
        }
      },0)
  })

  $('.js-todo-tabs').on('click', function() {
    window.setTimeout(function(){
      which_todo = $('.js-todo-tabs').find('.active > a').attr('href')
      if($('.js-active-tab').find('.active > a').attr('href') == '#todos') {
        $(which_todo).show()
        console.log(which_todo)
        if(which_todo == '#todo_current'){
          $('#todo_postponed').hide()
        }else{
          $('#todo_current').hide()
        }
      }
    }, 0)
  })

  });
