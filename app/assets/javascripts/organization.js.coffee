$ ->
  if $('.js-vacation-active').is(':checked')
    $('.js-vacation-container').show()

  $(document).on
    click: (e)->
      if $('.js-vacation-active').is(':checked')
        $('.js-vacation-container').show()
      else
        $('.js-vacation-container').hide()
  , '.js-vacation-active'



# simple_form overwrite
$ ->
  $('select[id*="start_vacation_date"]').wrapAll('<div class="row">');
  $('select[id*="start_vacation_date"]').wrap('<div class="col-xs-12 col-md-4">');
  $('select[id*="end_vacation_date"]').wrapAll('<div class="row">');
  $('select[id*="end_vacation_date"]').wrap('<div class="col-xs-12 col-md-4">');
