'use strict';

function hostToWS(host, ssl) {
    if (ssl === void 0) { ssl = false; }
    host = host.replace(/^(https?:\/\/)?/, '');
    return "ws" + (ssl ? 's' : '') + "://" + host;
}

$(function() {

    $('.js-rocket-chat-start').click(function(event){
        event.preventDefault();
        if ($('#js-chat-element').html().trim() === ''){
            $.ajax({
                url: $('.js-rocket-chat-room').attr('href'),
                method: 'GET',
                success: function (respond) {
                    ReactDOM.render(
                      React.createElement(Chat, {
                          theme: 'teal',
                          config: {
                              host: $('.js-rocketchat-url').data('url'),
                              rId: respond.id,
                              dmUid: $('.js-rc-seeker-username').data('id'),
                              dmUsername: $('.js-rc-seeker-username').data('username')
                          }
                      }),
                      document.getElementById('js-chat-element')
                    );


                },
                error: function (respond) {
                    var _error;
                    _error = respond.responseJSON['error'];
                    toastr.error(_error, 'Error');
                    return null
                }
            });
        }


        if ($(this).hasClass('sj-hide-animation')){
            $(this).removeClass('sj-hide-animation')
        }else{
            $(this).addClass('sj-hide-animation')
        }


        if ($('#js-chat-seeker-container').is(':hidden')){
            $('#js-chat-seeker-container').slideDown()
            $('.js-number-unread-messages').text('')
            $('.js-number-unread-messages').hide()
        } else {
            $('#js-chat-seeker-container').slideUp()
        }
    });

    // List seekers
    if($('.js-list-seeker-rocket-chat-inbox').length > 0){
        console.log(hostToWS($('.js-rocketchat-url').data('url'), true) + "/websocket")
        var realTimeAPI = new window.rcRealTimeAPI(hostToWS($('.js-rocketchat-url').data('url'), true) + "/websocket");
        realTimeAPI.connectToServer();
        realTimeAPI.keepAlive().subscribe();
        realTimeAPI.onMessage((data) => {
            if(data.msg === "changed" && data.collection === "stream-room-messages"){
                if (data.fields.args[0].unread){
                    let container_inbox = $("div").find("[data-username='" + data.fields.args[0].u.username + "']").closest('.js-list-seeker-rocket-chat-inbox');
                    $('.js-rocket-chat-inbox-counter', container_inbox).text(Number($('.js-rocket-chat-inbox-counter', container_inbox).text()) + 1)
                    if (!$('.js-rocket-chat-inbox-icon', container_inbox).hasClass('fas')){
                        $('.js-rocket-chat-inbox-icon', container_inbox).removeClass('fal')
                        $('.js-rocket-chat-inbox-icon', container_inbox).addClass('fas')
                    }
                }
                $.ajax({
                  url: '/broker/rocketchats/update_unread_messages',
                  method: 'POST',
                  data: {
                    broker_id: $('.js-current-broker-rc-id').data('rcid'),
                    seeker_username: data.fields.args[0].u.username,
                    timestamp: data.fields.args[0].ts.$date
                  },
                  error: function (respond) {
                    var _error;
                    _error = respond.responseJSON['error'];
                    toastr.error(_error, 'Error');
                    return null
                  }
                });
            }
        })

        realTimeAPI.sendMessage({
            "msg": "method",
            "method": "rooms/get",
            "id": $('.js-current-broker-rc-id').data('rcid'),
            "params": [ { "$date": 0 } ]
        })

        // this loop is to subscribe to websocket to allow it getting the messages
        $('.js-list-seeker-rocket-chat-inbox').each(function(index){
            const dataHolder = $(this).find('.js-rc-seeker-username')
            const userToken = dataHolder.data('userToken')
            const roomId = dataHolder.data('roomId')
            realTimeAPI.loginWithAuthToken(userToken);
            realTimeAPI.sendMessage({
                "msg": "sub",
                "name": "stream-room-messages",
                "params": [
                  roomId,
                  {"useCollection": false, "args": []}
                ],
                "id": "ddp-" + index
            })
        })


    }

    $('.js-list-seeker-rocket-chat-inbox').click(function(event){
        event.preventDefault();

        let rcUrl = $('.js-rocket-chat-seeker-edit', $(this)).attr('href')
        window.location = rcUrl;

    });

    // seeker edit
    if ( $('.js-rocket-chat-room').length > 0 ){
        console.log(hostToWS($('.js-rocketchat-url').data('url'), true) + "/websocket")
        var realTimeAPI = new window.rcRealTimeAPI(hostToWS($('.js-rocketchat-url').data('url'), true) + "/websocket");

        realTimeAPI.connectToServer();
        realTimeAPI.keepAlive().subscribe();

        realTimeAPI.onMessage((data) => {
            if(data.msg === "changed" && data.collection === "stream-room-messages"){
                if (data.fields.args[0].unread){
                    $('.js-number-unread-messages').text(Number($('.js-number-unread-messages').text()) + 1)
                    if (!$('.js-rocket-chat-start').hasClass('sj-hide-animation')){
                        $('.js-number-unread-messages').show();
                    }
                }
            }
        })



        $.ajax({
            url: $('.js-rocket-chat-room').attr('href'),
            method: 'GET',
            success: function (respond) {
                realTimeAPI.loginWithAuthToken(respond.user_token);
                realTimeAPI.sendMessage({
                    "msg":"sub",
                    "name":"stream-room-messages",
                    "params":[
                      respond.id,
                      {"useCollection":false,"args":[]}
                    ],
                    "id":"ddp-1"
                })
                realTimeAPI.sendMessage({
                    "msg": "method",
                    "method": "rooms/get",
                    "id": $('.js-current-broker-rc-id').data('rcid'),
                    "params": [ { "$date": 0 } ]
                })
            }
        })





        var chatDiv = document.createElement("div");
        chatDiv.id = "js-chat-element";

        chatDiv.style="width: 100%; height: 500px;"
        $('#js-chat-seeker').append(chatDiv)

        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        const chat = urlParams.get('chat')
        if (chat === 'open'){
            // Click have to be after definition click event
            $('.js-rocket-chat-start').click()
        }
    }
})


