'use strict';

$(function(){
    $('.js-message-to-all-rocketchat').click(function(event){
        event.preventDefault()
        $('#js-rocket-chat-broadcast-modal').modal('show')
        $('#js-rocket-chat-broadcast-modal').on('shown.bs.modal', function(){
        
            
        })
    })



    $('.js-send-broadcast-rocketchat').click(function(event){
        event.preventDefault()
        let hash = {}
        let that = $(this)
        let url = $('form', $('#js-rocket-chat-brodcast-container')).attr('action')
        let message = $('textarea', $('#js-rocket-chat-brodcast-container')).val()
        that.addClass('disabled')
        setTimeout(function(){
            if (message == ""){
                alert("Die Nachricht darf nicht leer sein")
                that.removeClass('disabled')
            }else{

                
                $('input.sj-checkbox-tag[type=checkbox]:checked').each(function () {
                    let rc_username = $(this).data('rc-name')
                    if (rc_username != undefined && rc_username != '' && hash[rc_username] == undefined){
                        hash[rc_username] = 1
                        console.log(rc_username)
                        // console.log(url)
                        // console.log(message)
                        $.ajax({
                            url: url,
                            type: 'POST',
                            async: false,
                            data: {
                                message: message,
                                rc_username: rc_username
                            },
                            success: function(result) {
                            
                            },
                            error: function(result){
                                console.log(result.responseJSON.error);
                            }
                        });
                    }    
                });
                that.removeClass('disabled')
                alert("Die Nachricht wurde versendet")

            }
        }, 500)
    });
})