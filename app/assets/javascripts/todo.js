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
          tr_last.append("<td>"+result.postponed+"</td>")
          $('.js-todo-postponed').find('tbody').prepend(tr_last)
          $('.js-todo-tabs > li > a[href="#todo_postponed"] > .sj-text-red').html($('#todo_postponed').find('tbody').find('tr').length)
          $('.js-todo-tabs > li > a[href="#todo_current"] > .sj-text-red').html($('#todo_current').find('tbody').find('tr').length-1)
        }
				toastr.info(result.message)
        // $('.js-postpone-msg').text(result.message)
        // $('.js-postpone-msg').show();
        // setTimeout(function(){$('.js-postpone-msg').hide()}, 3000)
        tr.remove()
				$.each($('.js-todo-tabs li'), function(){
					if($(this).hasClass('active')){
						_that = $("a", $(this))
						value = $("tr.organization", $(_that.attr('href'))).length - $("tr.display-none", $(_that.attr('href'))).length
						$("span",$("[href='#todos']")).text("("+value+")")
					}
				})
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
        if(which_todo == '#todo_current'){
          $('#todo_postponed').hide()
        }else{
          $('#todo_current').hide()
        }
      }
    }, 0)
  })

	$('.js-todo-completed').on('click', function(event) {
		event.preventDefault
		_url = $(this).data('url')
		_return_url = $(this).data('url-undo')
		_tr = $(this).closest('tr')
		$.ajax({
			method: "POST",
			url: _url,
			success: function(response){
				_tr.hide()
				toastr.options.positionClass =  "toast-bottom-left";
				toastr.options.timeOut =  10000;
				toastr.options.onclick = function () {
					$.ajax({
						method: "POST",
						url: _return_url,
						success: function (response) {
							_tr.show()
						},
						error: function (result) {
							toastr.error(result.responseJSON.error, 'Error');
						}
					})
				};
				toastr.info("<span class=\"btn btn-success\">Rückgängig machen</span>", 'Gelöscht.')
			},
			error: function(result){
				toastr.error(result.responseJSON.error, 'Error');
			}
		})

	})

})
