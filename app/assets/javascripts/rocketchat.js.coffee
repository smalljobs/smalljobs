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

  $('#js-rocket-chat-modal').on 'shown.bs.modal', (e)->
    $('.js-rocketchat-icon').removeClass('sj-rotate')
    if $('.js-rocket-chat-room').length
      getRoomId()
    else if $('.js-rc-seeker-username').length and $('.js-rc-seeker-username').data('username').length == 0
      toastr.error($('.js-rc-seeker-username').data('error'), 'Error')

  $(document).on
    click: (e)->
      e.preventDefault()
      $('.js-rocketchat-icon').addClass('sj-rotate')
      $('#js-rocket-chat-modal').modal('show')
  , '.js-rocketchat-icon'




  $(document).on
    click: (e)->
      e.preventDefault()
      $.ajax
        url: $(@).attr('href')
        method: 'POST'
        data:
          rc_username:  $('.js-rc-seeker-username').data('username')
          message: $('.js-pdf-message-modal .textarea').text()
        success: (respond)->
          $('#js-rocket-chat-modal').modal('show')
        error: (respond)->
          _error = respond.responseJSON['error']
          toastr.error(_error, 'Error')
  , '.js-pdf-message-rc'

  $(document).on
    click: (e)->
      e.preventDefault()
      _classes = $(@)[0].classList
      _click_class = null
      _regex = RegExp('js-.{1,}-rc$')
      _classes.forEach ((value, key, listObj) ->
        if _regex.test(value)
          _click_class = value
      )

      _modal_class = _click_class.replace("-rc", "-modal-rc")

      $.ajax
        url: $(@).attr('href')
        method: 'POST'
        data:
          rc_username:  $('.js-rc-seeker-username').data('username')
          message: $(".#{_modal_class} .textarea").text()
        success: (respond)->
          $('#js-rocket-chat-modal').modal('show')
          if $(".#{_modal_class} .js-change-state").length
            $(".#{_modal_class} .js-change-state").click()
        error: (respond)->
          _error = respond.responseJSON['error']
          toastr.error(_error, 'Error')
  , " .js-open-to-active-rc, .js-open-to-rejected-rc, .js-open-to-nothing-rc," +
      ".js-rejected-to-active-rc, .js-rejected-to-nothing-rc, .js-proposal-to-active-rc, .js-proposal-to-deleted-rc," +
      ".js-proposal-to-nothing-rc, .js-active-to-nothing-rc, .js-active-send-contract-rc, .js-active-to-finished-rc," +
      ".js-active-to-canceled-rc, .js-finished-to-active-rc, .js-finished-to-nothing-rc, .js-finished-to-active-rc," +
      ".js-finished-to-nothing-rc, .js-retracted-to-active-rc, .js-retracted-to-nothing-rc"


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
