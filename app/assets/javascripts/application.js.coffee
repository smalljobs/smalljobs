#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require social-share-button
#= require sortable.js
#= require_tree .

ready = ->
  history_array = JSON.parse(sessionStorage.getItem('history') || null)
  if history_array != null
    if history_array.length > 0 && history_array[history_array.length-1] == window.location.href
      k = 1
    else
      history_array.push(window.location.href)
  else
    history_array = []
    history_array.push(window.location.href)

  sessionStorage.setItem('history', JSON.stringify(history_array))

  previousUrl = sessionStorage.getItem('previous') || '';
  goBack = sessionStorage.getItem('goBack') || -1;
  if previousUrl == window.location.href
    goBack -= 1;
  else
    goBack = -1;

  sessionStorage.setItem('previous', window.location.href);
  sessionStorage.setItem('goBack', goBack);

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
      $('#seeker_status_inactive').prop('checked', true);
  ).change();

  $('#seeker_discussion').change(->
    if $(@)[0].checked && $('#seeker_parental')[0].checked
      $('#seeker_status_active').prop('disabled', false);
    else
      $('#seeker_status_active').prop('disabled', true);
      $('#seeker_status_inactive').prop('checked', true);
  ).change();

  $('.back_button').click(->
#    sessionStorage.setItem('shouldRefresh', true);
#    history.go(goBack);
    url = history_array.pop()
    url = history_array.pop()
    sessionStorage.setItem('history', JSON.stringify(history_array))
    console.log(url)
    window.location.href = url
  );


$(document).ready(ready);
