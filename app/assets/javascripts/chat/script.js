'use strict';

// document.cookie = `rc_token=REACT_APP_RC_TOKEN; path=/;`;
// document.cookie = `rc_uid=REACT_APP_RC_UID; path=/;`;
// document.cookie = `rc_username=REACT_APP_RC_USERNAME; path=/;`;

// ReactDOM.render(
//     React.createElement(Chat, {
//         config: {
//             host : 'REACT_APP_RC_HOST',
//             rId : 'REACT_APP_RC_RID',
//             dmUid : 'REACT_APP_RC_DM_UID_1',
//             dmUsername : 'REACT_APP_RC_DM_USERNAME_1'
//         }
//     }),
//     document.getElementById('chat')
// );
// document.cookie = `rc_token=w9BQoyl0s_qh1f-kXN5leMyVPElibW0dtB3RFxuLx3w; path=/;`;
// document.cookie = `rc_uid=2LHCpta8DyyDcWBgX; path=/;`;
// document.cookie = `rc_username=rest_admin; path=/;`;
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
        $('#js-chat-seeker-container').slideDown()
        
        // Umieszczanie w modalu 
        // chatDiv.style="width: 100%; height: 0px;"
        // $('#js-rocketchat-iframe-container').append(chatDiv)
        // $('#js-rocket-chat-modal').modal('show')
        // $('#js-rocket-chat-modal').on('shown.bs.modal', function(){
        //     var height = $('#js-rocketchat-iframe-container').height()
        //     $('#js-chat-element').height(height)
        // })


        
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




    // $('.show1').click(function(event){
    //     event.preventDefault();
        
    //     var oldChat = document.getElementById('chat1');
    //     if (oldChat){
    //         ReactDOM.unmountComponentAtNode(oldChat);
    //         oldChat.remove();
    //     }
        
    //     var chatDiv = document.createElement("div");
    //     chatDiv.id = "chat1";
    //     chatDiv.style="width: 300px; height: 400px;"
    //     document.getElementById('chat_container').appendChild(chatDiv)
    //     setTimeout(function(){
    //         ReactDOM.render(
    //             React.createElement(Chat, {
    //                 config: {
    //                     host : 'https://staging.jugend.online',
    //                     rId : '2LHCpta8DyyDcWBgXHZyMKqpfF9ppJ4DDy',
    //                     dmUid : 'HZyMKqpfF9ppJ4DDy',
    //                     dmUsername : 'mob1'                        
    //                 }
    //             }),
    //             document.getElementById('chat1')
    //         );
    //     }, 1000)
    // });  
    

   

})


