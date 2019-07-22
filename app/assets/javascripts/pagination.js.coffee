$ ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      url = $('.pagination .next a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
        $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $.getScript url
      return
    return
#
##
#jQuery ->
#  if $('.pagination').length
#    $('#todos').scroll ->
#      url = $('.pagination .next a').attr('href')
#      if url &&  $('#todos')[0].scrollHeight -
#        $('#todos').scrollTop() < 700
#        $('.pagination').text('Fetching more data...')
#        $.getScript(url)
#        $('#todos').scroll()

#
#$ ->
#  if $('.pagination').length && $('#todos_body').length
#    $(window).on 'scroll', ->
#      url = $('.pagination .next a').attr('href')
#      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
##        $('.pagination').text('Fetching more data...')
#        $.getScript(url)
#    $(window).scroll()


#jQuery ->
#  if $('.pagination').length
#    $(window).on 'scroll', ->
#      console.log("scroll")
#      url = $('.pagination .next a').attr('href')
#      if url && $('#todos_body')[0].scrollHeight - $('#todos_body').scrollTop() < 700
##        $('.pagination').text('Fetching more data...')
#        $.getScript(url)
#        $(window).off('scroll');
#$(window).on('scroll')