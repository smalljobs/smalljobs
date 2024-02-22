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
                    let seeker_id = $(this).data('seeker-id')
                    if (rc_username != undefined && rc_username != '' && hash[rc_username] == undefined){
                        hash[rc_username] = 1
                        $.ajax({
                            url: url,
                            type: 'POST',
                            async: false,
                            data: {
                                message: message,
                                rc_username: rc_username,
                                seeker_id: seeker_id
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
                $('#js-rocket-chat-broadcast-modal').modal('hide');

            }
        }, 1000)
    });

    $('.js-message-show-all-broadcast').click(function(event){
        event.preventDefault()
        let url = $(this).attr('href')
        
        $.ajax({
            url: url,
            type: 'get',
            success: function(result) {
                $('.js-rocket-chat-message').text(result.message) 
                let seekers = result.seekers
                var seekers_tekst = ""
                for (const seeker of seekers) {
                    if (seekers_tekst == ""){
                        seekers_tekst = seeker
                    }else{
                        seekers_tekst = seekers_tekst + ", " + seeker
                    }
                }
                $('.js-rocket-chat-seekers-list').text(seekers_tekst);
                $('#js-rocket-chat-all-broadcast-seekers-modal').modal('show')
                $('#js-rocket-chat-all-broadcast-seekers-modal').on('shown.bs.modal', function(){
        })
            },
            error: function(result){
                console.log(result.responseJSON.error);
                alert(result.responseJSON.error)
                $('#js-rocket-chat-all-broadcast-seekers-modal').modal('hide');
            }
        });    
    

    })

    $('.js-rocket-chat-broadcast-list-link').click(function(event){
        event.preventDefault()
        if ($('.js-rocket-chat-change-caret', $(this)).hasClass('fa-caret-down')){
            $('.js-rocket-chat-change-caret', $(this)).removeClass('fa-caret-down')
            $('.js-rocket-chat-change-caret', $(this)).addClass('fa-caret-up') 
            $('.js-rocket-chat-broadcast-list').removeClass('display-none')
        }else{
            $('.js-rocket-chat-change-caret', $(this)).removeClass('fa-caret-up')
            $('.js-rocket-chat-change-caret', $(this)).addClass('fa-caret-down')
            $('.js-rocket-chat-broadcast-list').addClass('display-none') 
        }
    })
})