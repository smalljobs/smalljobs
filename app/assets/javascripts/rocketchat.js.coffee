$ ->
  window.iframeEl = null
  window.url = null
  $.ajax
    url: $(".js-rocketchat-icon").attr('href')
    method: 'POST'
    success: (respond)->
      generateIframe(respond.user_id, respond.auth_token, respond.url)
      window.url = respond.url
    error: (respond)->
      _error = respond.responseJSON['error']
      toastr.error(_error, 'Error')

  $(document).on
    click: (e)->
      e.preventDefault()
      $('.js-rocketchat-icon').addClass('sj-rotate')
      $('#js-rocket-chat-modal').modal('show')
  , '.js-rocketchat-icon'

  $('#js-rocket-chat-modal').on 'shown.bs.modal', (e)->
    $('.js-rocketchat-icon').removeClass('sj-rotate')
    if $('.js-rocket-chat-room').length
      getRoomId()
    else if $('.js-rc-seeker-username').length and $('.js-rc-seeker-username').data('username').length == 0
      toastr.error($('.js-rc-seeker-username').data('error'), 'Error')

generateIframe = (user_id, token, url)->
  if $("#js-rocketchat-iframe")
    $("#js-rocketchat-iframe").remove()
  window.iframeEl = document.createElement('iframe')
  window.iframeEl.id = 'js-rocketchat-iframe'
  window.iframeEl.src = url+"/extras-ji/"+'?uid='+user_id+'&token='+token;
  window.iframeEl.style = "width: 100%; height: 500px;"
  window.iframeEl.frameBorder = "0"
  $('.js-rocketchat-iframe-container').append(iframeEl);
  $("#js-rocketchat-iframe").on 'load', ->
    if $(@).attr('src') != url+"/home"
      window.iframeEl.src = url+"/home"



getRoomId = ()->
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
