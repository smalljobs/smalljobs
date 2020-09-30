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


  $('#js-rocket-chat-modal').on 'hidden.bs.modal', (e)->
    if window.redirect_href?
      window.location.href = window.redirect_href
    else if $('.js-reload-after-close-rc').length
      window.location.reload();
  if $(".js-recketchat-present").length
    $(" .js-open-to-active-modal-rc, .js-open-to-rejected-modal-rc, .js-open-to-nothing-modal-rc," +
      ".js-rejected-to-active-modal-rc, .js-rejected-to-nothing-modal-rc, .js-proposal-to-active-modal-rc, .js-proposal-to-deleted-modal-rc," +
      ".js-proposal-to-nothing-modal-rc, .js-active-to-nothing-modal-rc, .js-active-send-contract-modal-rc, .js-active-to-finished-modal-rc," +
      ".js-active-to-canceled-modal-rc, .js-finished-to-active-modal-rc, .js-finished-to-nothing-modal-rc, .js-finished-to-active-modal-rc," +
      ".js-finished-to-nothing-modal-rc, .js-retracted-to-active-modal-rc, .js-retracted-to-nothing-modal-rc").on 'show.bs.modal', (e)->
        if $(".js-rocket-chat-room").length == 0
          $(".modal .textarea").hide()


  $(document).on
    click: (e)->
      e.preventDefault()
      $('.js-rocketchat-icon').addClass('sj-rotate')
      $('#js-rocket-chat-modal').modal('show')
      $('.js-rocketchat-icon span').addClass('hidden')
  , '.js-rocketchat-icon'

  getUnread()



  $(document).on
    click: (e)->
      e.preventDefault()
      $.ajax
        url: $(@).data('href')
        method: 'POST'
        data:
          rc_username:  $('.js-rc-seeker-username').data('username')
          message: $('.js-pdf-message-modal .textarea').text()
        success: (respond)->
          $('.js-pdf-message-modal').modal('hide')
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
      if $(".js-rocket-chat-room").length > 0
        $.ajax
          url: $(@).data('href')
          method: 'POST'
          data:
            rc_username:  $('.js-rc-seeker-username').data('username')
            message: $(".#{_modal_class} .textarea").text()
          success: (respond)->
            $(".#{_modal_class}").modal('hide')
            $('#js-rocket-chat-modal').modal('show')
  #          if $(".#{_modal_class} .js-change-state").length
  #            $(".#{_modal_class} .js-change-state").click()
          error: (respond)->
            _error = respond.responseJSON['error']
            toastr.error(_error, 'Error')
  , " .js-open-to-active-rc, .js-open-to-rejected-rc, .js-open-to-nothing-rc," +
      ".js-rejected-to-active-rc, .js-rejected-to-nothing-rc, .js-proposal-to-active-rc, .js-proposal-to-deleted-rc," +
      ".js-proposal-to-nothing-rc, .js-active-to-nothing-rc, .js-active-send-contract-rc, .js-active-to-finished-rc," +
      ".js-active-to-canceled-rc, .js-finished-to-active-rc, .js-finished-to-nothing-rc, .js-finished-to-active-rc," +
      ".js-finished-to-nothing-rc, .js-retracted-to-active-rc, .js-retracted-to-nothing-rc"
  $(document).on
    click: (e)->
      e.preventDefault()
      $('.js-rocketchat-icon').addClass('sj-rotate')
      $('#js-rocket-chat-modal').modal('show')
      $('.js-rocketchat-icon span').addClass('hidden')
      _this = $(@)
      $.ajax
        url: _this.attr('href')
        method: 'POST'
        data: rc_usernames: $.map window.seekersList.visibleItems, (v)->
          v['_values']['rc_username']
        success: (respond)->
          document.getElementById('js-rocketchat-iframe').contentWindow.postMessage({
            externalCommand: 'go',
            path: '/group/'+respond.name
          }, '*')
        error: (respond)->
          _error = respond.responseJSON['error']
          toastr.error(_error, 'Error')
          $('.js-rocketchat-icon').removeClass('sj-rotate')
  , ".js-message-to-all-rc"

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





getUnread = ()->
  $.ajax
    url: $('.js-rocketchat-icon').data('unread')
    method: 'GET'
    success: (respond)->
      if respond.unread > 0
        $('.js-rocketchat-icon span').removeClass('hidden')
    error: (respond)->
      _error = respond.responseJSON['error']
      toastr.error(_error, 'Error')


$ ->
  setInterval ()->
    if $('.js-rocketchat-icon span').hasClass('hidden') and $("#js-rocket-chat-modal").css("display") != "block"
      getUnread()
  , 5000
