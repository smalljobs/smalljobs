$ ->
  $(document).on
    click: (e)->
      console.log 'hello'
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
          console.log 'succes'
          toastr.success('Success!', 'Message')
          _btn.button('reset')
        error: ()->
          console.log 'error'
          toastr.error('Error', 'Message')
          _btn.button('reset')

  , '.js-feedback-send'

