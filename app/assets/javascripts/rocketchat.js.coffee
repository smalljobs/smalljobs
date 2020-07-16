$ ->
  $(document).on
    click: (e)->
      e.preventDefault()
      $('.js-rocketchat-icon').addClass('sj-rotate')

      $.ajax
        url: $(@).attr('href')
        method: 'POST'
        success: (respond)->
#          toastr.success('Gespeichert!')
          generateIframe(respond.user_id, respond.auth_token, respond.url)
        error: (respond)->
          _error = respond.responseJSON['error']
          toastr.error(_error, 'Error')
          $('.js-rocketchat-icon').removeClass('sj-rotate')

  , '.js-rocketchat-icon'

generateIframe = (user_id, token, url)->
  if $("#js-rocketchat-iframe")
    $("#js-rocketchat-iframe").remove()
  iframeEl = document.createElement('iframe')
  iframeEl.id = 'js-rocketchat-iframe'
  iframeEl.src = url+"/extras-ji/"+'?uid='+user_id+'&token='+token;
  iframeEl.style = "width: 100%; height: 500px;"
  iframeEl.frameBorder = "0"
  $('.js-rocketchat-iframe-container').append(iframeEl);
  $("#js-rocketchat-iframe").on 'load', ->
    if $(@).attr('src') != url+"/home"
      iframeEl.src = url+"/home"
    else
      $('#js-rocket-chat-modal').modal('show')
      $('#js-rocket-chat-modal').on 'shown.bs.modal', (e)->
        $('.js-rocketchat-icon').removeClass('sj-rotate')
        if $('.js-rocket-chat-room')
          getRoomId()

    return


getRoomId = ()->
  console.log "getRoom"
  $.ajax
    url: $('.js-rocket-chat-room').attr('href')
    method: 'GET'
    success: (respond)->
      document.getElementById('js-rocketchat-iframe').contentWindow.postMessage({
        externalCommand: 'go',
        path: '/direct/'+respond.id
      }, '*')
    error: (respond)->
      _error = respond.responseJSON['error']
      toastr.error(_error, 'Error')
      $('.js-rocketchat-icon').removeClass('sj-rotate')
