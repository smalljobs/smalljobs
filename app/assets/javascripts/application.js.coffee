#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require social-share-button
#= require_tree .

ready = ->
  $('#job_date_type').change(->
    switch $(@).val()
      when 'agreement', ''
        $('.job_start_date').slideUp()
        $('.job_end_date').slideUp()
      when 'date'
        $('.job_start_date').slideDown()
        $('.job_end_date').slideUp()
      when 'date_range'
        $('.job_start_date').slideDown()
        $('.job_end_date').slideDown()
  ).change()

$(document).ready(ready)
