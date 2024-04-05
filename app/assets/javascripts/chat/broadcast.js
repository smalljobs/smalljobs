'use strict';

$(function(){
    $('.js-message-to-all-rocketchat').click(function(event){
        event.preventDefault()
        if (!$('.js-rocket-chat-broadcast-list-unchecked').hasClass('hidden')){
            $('.js-rocket-chat-broadcast-list-unchecked').addClass('hidden')
            $('.js-rocket-chat-broadcast-add-more-recipient').removeClass('hidden')
        }
        $.map(window.seekersList.items, function(v) {
            $("#seeker_"+v['_values']['id']).prop('checked', false);
            $("#seeker_"+v['_values']['id']).parent('label').detach().appendTo('.js-rocket-chat-broadcast-list-unchecked')
          })

        $.map(window.seekersList.visibleItems, function(v) {
            $("#seeker_"+v['_values']['id']).prop('checked', true);
            $("#seeker_"+v['_values']['id']).parent('label').detach().appendTo('.js-rocket-chat-broadcast-list-checked')
          })
        hiddenShowMoreRecipient()
        $('#js-rocket-chat-broadcast-modal').modal('show')
        $('#js-rocket-chat-broadcast-modal').on('shown.bs.modal', function(){
        checkboxLength()
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
        $('.js-rocket-chat-message').text("")
        let url = $(this).attr('href')

        $.ajax({
            url: url,
            type: 'get',
            success: function(result) {
                for (const record of result){
                    let strong_created_at = document.createElement('strong');
                    let div_container = document.createElement('div');
                    let div_message = document.createElement('div');
                    let div_seekers = document.createElement('div');
                    let div_seekers_show = document.createElement('div');
                    div_seekers_show.classList.add('sj-rocket-chat-seeker-show')
                    div_seekers_show.classList.add('js-rocket-chat-seeker-show')
                    div_seekers_show.innerHTML += 'Alle Empfänger anzeigen'
                    div_seekers.classList.add('sj-rocket-chat-seeker-lists')
                    strong_created_at.innerHTML += record.created_at
                    div_message.innerHTML += record.message
                    let seekers_tekst = ""
                    let seekers = record.seekers
                    for (const seeker of seekers) {
                        if (seekers_tekst == ""){
                            seekers_tekst = seeker
                        }else{
                            seekers_tekst = seekers_tekst + ", " + seeker
                        }
                    }
                    div_seekers.innerHTML += seekers_tekst
                    div_container.append(strong_created_at)
                    div_container.append(div_message)
                    div_container.append(div_seekers)
                    div_container.append(div_seekers_show)

                    $('.js-rocket-chat-message').append(div_container)
                }



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

    $(document).on({
        click: function(e){
            e.preventDefault()
            $('.sj-rocket-chat-seeker-lists', $(this).parent()).show();
            $(this).hide()

        }

    }, '.js-rocket-chat-seeker-show')


    $('.js-broadcast-checkbox-tag').click(function(event) {
        let i = $('input.js-broadcast-checkbox-tag[type=checkbox]:checked').length
        $('#js-rocket-chat-recipients-count').text(i);

    })

    $('.js-rocket-chat-broadcast-add-more-recipient').click(function(e) {
        e.preventDefault()
        if ($('.js-rocket-chat-broadcast-list-unchecked').hasClass('hidden')){
            $('.js-rocket-chat-broadcast-list-unchecked').removeClass('hidden')
            $('.js-rocket-chat-broadcast-add-more-recipient').addClass('hidden')
        }
    })
})

function checkboxLength(){
    let i = $('input.js-broadcast-checkbox-tag[type=checkbox]:checked').length
    $('#js-rocket-chat-recipients-count').text(i);
}

function hiddenShowMoreRecipient(){
    
    if ( $('input.js-broadcast-checkbox-tag[type=checkbox]', $('.js-rocket-chat-broadcast-list-unchecked')).length === 0 ){
        $('.js-rocket-chat-broadcast-add-more-recipient').addClass('hidden')
    }
}
