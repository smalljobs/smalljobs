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
          toastr.success('Gespeichert!')
          _btn.button('reset')
        error: (respond)->
          _error = respond.responseJSON['error'][0]
          toastr.error(_error, 'Error')
          _btn.button('reset')

  , '.js-feedback-send'



  $(document).on
    click: (e)->
      e.preventDefault()
      tinyMCE.activeEditor.setContent($(@).data('content'));
  , '.js-job-certifacate-reset'

  $(document).on
    click: (e)->
      e.preventDefault()
      $.ajax
        url: $(@).attr('href')
        method: 'PUT'
        data:
          jobs_certificate:
            content: tinyMCE.activeEditor.getContent()
        success: (respond)->
          toastr.success('Gespeichert!')
          window.open(respond['pdf_link'], '_blank');
        error: (respond)->
          _error = respond.responseJSON['error'][0]
          toastr.error(_error, 'Error')


  , '.js-job-certificate-pdf'


