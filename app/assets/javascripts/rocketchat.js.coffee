$ ->
  $(document).on
    click: (e)->
      e.preventDefault()
      $.ajax
        url: $(@).attr('href')
        method: 'POST'
        success: (respond)->
          toastr.success('Gespeichert!')
          generateIframe(respond.user_id, respond.auth_token)
        error: (respond)->
          _error = respond.responseJSON['error']
          toastr.error(_error, 'Error')

  , '.js-rocketchat-icon'

generateIframe = (user_id, token)->
  iframeEl = document.createElement('iframe')
  iframeEl.id = 'js-rocketchat-iframe'
#  iframeEl.style.display = 'none'
  iframeEl.src = "https://staging.jugend.online/extras-ji/"+'?uid='+user_id+'&token='+token;
  $('.js-rocketchat-iframe-container').append(iframeEl);
  iframeEl.src = "https://staging.jugend.online/home"

