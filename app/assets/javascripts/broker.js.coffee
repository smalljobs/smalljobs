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
      _this = $(@)
      e.preventDefault()
      e.stopPropagation()
      $.ajax
        url: _this.data('url')
        method: 'PUT'
        data:
          jobs_certificate:
            content: tinyMCE.activeEditor.getContent()
        success: (respond)->
          toastr.success('Gespeichert!')
          setTimeout (event)=>
            window.open(respond['pdf_link'], '_blank');
          , 500
        error: (respond)->
          e.preventDefault()
          _error = respond.responseJSON['error'][0]
          toastr.error(_error, 'Error')


  , '.js-job-certificate-pdf'



  $(document).on
    click: (e)->
      e.preventDefault()
      _btn = $(@).button('loading')
      $.ajax
        url: $(@).data('url')
        method: 'PUT'
        data:
          seeker:
            organization_id: $('.js-seeker-transfer-organization-select option:selected').val()
        success: (respond)->
          toastr.success('Gespeichert!')
          _btn.button('reset')
        error: (respond)->
          _error = respond.responseJSON['error'][0]
          toastr.error(_error, 'Error')
          _btn.button('reset')


  , '.js-seeker-region-transfer'
