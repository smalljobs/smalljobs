$ ->
  $(document).on
    click: (e)->
      e.preventDefault()
      _btn = $(@).button('loading')
      _container = $(@).parents('.js-feedback-container')
      $.ajax
        url: $(@).data('url')
        method: 'PUT'
        data:
          allocation:
            "#{$("textarea", _container).attr('id')}": $("textarea", _container).val()
        success: (respond)->
          toastr.success('Success!')
          _btn.button('reset')
        error: (respond)->
          _error = respond.responseJSON['error'][0]
          toastr.error(_error, 'Error')
          _btn.button('reset')

  , '.js-feedback-send'

