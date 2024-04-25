'use strict';


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



    $('.js-list-seeker-rocket-chat-inbox').click(function(event){
        event.preventDefault();
        let rcUrl = $('.js-rocket-chat-seeker-edit', $(this)).attr('href')
        window.location = rcUrl;
        // generateIframe(respond.user_id, respond.auth_token, respond.url);
        // var oldChat = document.getElementById('js-chat-element');
        // if (oldChat){
        //     ReactDOM.unmountComponentAtNode(oldChat);
        //     oldChat.remove();
        // }
        //
        // var chatDiv = document.createElement("div");
        // chatDiv.id = "js-chat-element";
        //
        // // chatDiv.style="width: 100%; height: 500px;"
        // // $('#js-chat-seeker').append(chatDiv)
        // // $('#js-chat-seeker-container').slideDown()
        //
        // let inboxIcon = $('.js-rocket-chat-inbox-icon', $(this))
        // let inboxCounter = $('.js-rocket-chat-inbox-counter', $(this))
        //
        // // Umieszczanie w modalu
        // chatDiv.style="width: 100%; height: 0px;"
        // $('#js-rocketchat-iframe-container').append(chatDiv)
        // $('#js-rocket-chat-modal').modal('show')
        // $('#js-rocket-chat-modal').on('shown.bs.modal', function(){
        //     var height = $('#js-rocketchat-iframe-container').height()
        //     $('#js-chat-element').height(height)
        //     inboxIcon.removeClass('fas').addClass('fal')
        //     var seeker_unread = parseInt(inboxCounter.text())
        //     inboxCounter.text('')
        //     inboxCounter.parents('.chat').attr('sorttable_customkey', 0)
        //     var sum = parseInt($('span', $('#js-tab-unread-messages')).text().replace("(",""))
        //     $('span', $('#js-tab-unread-messages')).text("("+(sum - seeker_unread).toString()+")")
        // })
        //
        // let rcUrl = $('.js-rocket-chat-room', $(this)).attr('href')
        // let rcId = $('.js-rocket-chat-room', $(this)).data('id')
        // let rcUsername = $('.js-rocket-chat-room', $(this)).data('username')
        //
        // $.ajax({
        //     url: rcUrl,
        //     method: 'GET',
        //     success: function(respond) {
        //         ReactDOM.render(
        //             React.createElement(Chat, {
        //                 theme: 'teal',
        //                 config: {
        //                     host : $('.js-rocketchat-url').data('url'),
        //                     rId : respond.id,
        //                     dmUid : rcId,
        //                     dmUsername : rcUsername
        //                 }
        //             }),
        //             document.getElementById('js-chat-element')
        //         );
        //     },
        //     error: function(respond) {
        //         var _error;
        //         _error = respond.responseJSON['error'];
        //         toastr.error(_error, 'Error');
        //         return null
        //     }
        // });
        //
    });

    if ( $('.js-rocket-chat-room').length > 0 ){

        var realTimeAPI = new window.rcRealTimeAPI("wss://staging.jugend.online/websocket");
        realTimeAPI.connectToServer();

        realTimeAPI.onMessage((data) => {
            // console.log(data);
            if(data.msg === "changed" && data.collection === "stream-room-messages"){
                if (data.fields.args[0].unread){
                    $('.js-number-unread-messages').text(Number($('.js-number-unread-messages').text()) + 1)
                    if (!$('.js-rocket-chat-start').hasClass('sj-hide-animation')){
                        $('.js-number-unread-messages').show();
                    }
                }
            }
        })
        realTimeAPI.keepAlive().subscribe();


        $.ajax({
            url: $('.js-rocket-chat-room').attr('href'),
            method: 'GET',
            success: function (respond) {
                realTimeAPI.loginWithAuthToken(respond.user_token);
                realTimeAPI.sendMessage({"msg":"sub","name":"stream-room-messages","params":[respond.id, {"useCollection":false,"args":[]}],"id":"ddp-1"})
                realTimeAPI.sendMessage({
                    "msg": "method",
                    "method": "rooms/get",
                    "id": "NiCSSmzWZMeMTTTqD",
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
            // $('#js-chat-seeker-container').slideDown()
            // $('.js-number-unread-messages').text('')
            // $('.js-number-unread-messages').hide()
            // $('.js-rocket-chat-start').addClass('sj-hide-animation')
        }




    }



})


