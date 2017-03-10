#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require social-share-button
#= require sortable.js
#= require_tree .

ready = ->
  $('#job_date_type').change(->
    switch $(@).val()
      when 'agreement', ''
        $('.job_start_date').slideUp();
        $('.job_end_date').slideUp();
      when 'date'
        $('.job_start_date').slideDown();
        $('.job_end_date').slideUp();
      when 'date_range'
        $('.job_start_date').slideDown();
        $('.job_end_date').slideDown();
  ).change();

  $('#job_salary_type').change(->
    switch $(@).val()
      when 'hourly_per_age'
        $('.job_salary').slideUp();
        $('#job_salary').prop('required', false);
        $('#job_salary').val('');
      when 'hourly'
        $('.job_salary').slideDown();
        $('#job_salary').prop('required', true);
      when 'fixed'
        $('.job_salary').slideDown();
        $('#job_salary').prop('required', true);
  ).change();

  $('#provider_contract').change(->
    if $(@)[0].checked
      $('#provider_active_true').prop('disabled', false)
    else
      $('#provider_active_true').prop('disabled', true)
      $('#provider_active_false').prop('checked', true)
  ).change();

  $('.back_button').click(->
    history.back();
  );


$(document).ready(ready);
