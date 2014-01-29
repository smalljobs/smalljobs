#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require_tree .

$(->
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
)
