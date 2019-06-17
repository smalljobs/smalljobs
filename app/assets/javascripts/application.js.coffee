#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require social-share-button
#= require sortable.js
#= require list.min.js
#= require contextHelp.js
#= require bootstrap-select.min.js
#= require_tree .
#= require todo.js
#= require bootstrap-datepicker.js
#= require chart.min.js

#= require jquery-ui
#= require autocomplete-rails
#= require shared.js
#= require jquery.form.min.js
#= require html2canvas.min.js

ready = ->
  history_array = JSON.parse(sessionStorage.getItem('history') || '[]')

  history_array.push(window.location.href)

  sessionStorage.setItem('history', JSON.stringify(history_array))

  shouldRefresh = sessionStorage.getItem('shouldRefresh');
  if shouldRefresh == true || shouldRefresh == 'true'
    sessionStorage.setItem('shouldRefresh', false);
    window.location.reload();


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
      $('#provider_state_active').prop('disabled', false);
    else
      $('#provider_state_active').prop('disabled', true);
      $('#provider_state_inactive').prop('checked', true);
  ).change();

  $('#seeker_parental').change(->
    if $(@)[0].checked && $('#seeker_discussion')[0].checked
      $('#seeker_status_active').prop('disabled', false);
    else
      $('#seeker_status_active').prop('disabled', true);
      if $('#seeker_status_active')[0].checked
        $('#seeker_status_inactive').prop('checked', true);
  ).change();

  $('#seeker_discussion').change(->
    if $(@)[0].checked && $('#seeker_parental')[0].checked
      $('#seeker_status_active').prop('disabled', false);
    else
      $('#seeker_status_active').prop('disabled', true);
      if $('#seeker_status_active')[0].checked
        $('#seeker_status_inactive').prop('checked', true);
  ).change();

  $('.back_button').click(->
    url = history_array.pop()
    new_url = history_array.pop()
    while(new_url == url)
      new_url = history_array.pop()

    sessionStorage.setItem('history', JSON.stringify(history_array))
    if new_url?
      window.location.href = new_url
    else
      window.location.href = '/broker/dashboard'
  );

  $('.notifications a.close').click(->
    $('div.notifications').addClass('display-none');
  );


$(document).ready(ready);
