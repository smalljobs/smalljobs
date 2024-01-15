'use strict';

$(function(){

    $('.js-rocket-chat-start').click(function(event){
        event.preventDefault();         
        // generateIframe(respond.user_id, respond.auth_token, respond.url);
        var oldChat = document.getElementById('js-chat-element');
        if (oldChat){
            ReactDOM.unmountComponentAtNode(oldChat);
            oldChat.remove();
        }
        
        var chatDiv = document.createElement("div");
        chatDiv.id = "js-chat-element";

        chatDiv.style="width: 100%; height: 500px;"
        $('#js-chat-seeker').append(chatDiv)
        if ($('#js-chat-seeker-container').is(':hidden')){
            $('#js-chat-seeker-container').slideDown()
            $('.js-number-unread-messages').text('')
        } else {
            $('#js-chat-seeker-container').slideUp()
        }

        
        $.ajax({
            url: $('.js-rocket-chat-room').attr('href'),
            method: 'GET',
            success: function(respond) {
                ReactDOM.render(
                    React.createElement(Chat, {
                        config: {
                            host : $('.js-rocketchat-url').data('url'),
                            rId : respond.id,
                            dmUid : $('.js-rc-seeker-username').data('id'),
                            dmUsername : $('.js-rc-seeker-username').data('username')
                        }
                    }),
                    document.getElementById('js-chat-element')
                );
            },
            error: function(respond) {
                var _error;
                _error = respond.responseJSON['error'];
                toastr.error(_error, 'Error');
                return null
            }
        });           
        
    });  

    

    $('.js-list-seeker-rocket-chat-inbox').click(function(event){
        event.preventDefault();         
        // generateIframe(respond.user_id, respond.auth_token, respond.url);
        var oldChat = document.getElementById('js-chat-element');
        if (oldChat){
            ReactDOM.unmountComponentAtNode(oldChat);
            oldChat.remove();
        }
        
        var chatDiv = document.createElement("div");
        chatDiv.id = "js-chat-element";

        // chatDiv.style="width: 100%; height: 500px;"
        // $('#js-chat-seeker').append(chatDiv)
        // $('#js-chat-seeker-container').slideDown()
        
        let inboxIcon = $('.js-rocket-chat-inbox-icon', $(this))
        let inboxCounter = $('.js-rocket-chat-inbox-counter', $(this))

        // Umieszczanie w modalu 
        chatDiv.style="width: 100%; height: 0px;"
        $('#js-rocketchat-iframe-container').append(chatDiv)
        $('#js-rocket-chat-modal').modal('show')
        $('#js-rocket-chat-modal').on('shown.bs.modal', function(){
            var height = $('#js-rocketchat-iframe-container').height()
            $('#js-chat-element').height(height)
            inboxIcon.removeClass('fas').addClass('fal')
            inboxCounter.text('')
            inboxCounter.parents('.chat').attr('sorttable_customkey', 0)

        })

        let rcUrl = $('.js-rocket-chat-room', $(this)).attr('href')
        let rcId = $('.js-rocket-chat-room', $(this)).data('id')
        let rcUsername = $('.js-rocket-chat-room', $(this)).data('username')
        
        $.ajax({
            url: rcUrl,
            method: 'GET',
            success: function(respond) {
                ReactDOM.render(
                    React.createElement(Chat, {
                        config: {
                            host : $('.js-rocketchat-url').data('url'),
                            rId : respond.id,
                            dmUid : rcId,
                            dmUsername : rcUsername
                        }
                    }),
                    document.getElementById('js-chat-element')
                );
            },
            error: function(respond) {
                var _error;
                _error = respond.responseJSON['error'];
                toastr.error(_error, 'Error');
                return null
            }
        });           
        
    });  
    



    

   

})


