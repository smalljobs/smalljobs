$ ->
  if $('#js-age-scroll').length > 0
    slider = document.getElementById('js-age-scroll')
    noUiSlider.create slider,
      start: [
        13
        19
      ]
      step: 1
      connect: true
      range:
        'min': 13
        'max': 19
    # Binding change
    slider.noUiSlider.on 'change', (values, handle, unencoded, tap, positions, noUiSlider) ->
      lower = document.getElementById('js-lower-value')
      higher = document.getElementById('js-higher-value')
      lower.innerHTML = if values[0] > 18 then '18+' else Math.round(values[0]) + 'j.'
      higher.innerHTML = if values[1] > 18 then '18+' else Math.round(values[1]) + 'j.'

      window.seekersList.filter (item) ->
        if values[1] < 19
          values_1 = values[1]
        else
          values_1 = 100
        if item.values().age >= Math.round(values[0]) and item.values().age <= Math.round(values_1)
          true
        else
          false
      # Only items with id > 1 are shown in list
  #    listObj.filter()
      return


    values = slider.noUiSlider.get()
    lower = document.getElementById('js-lower-value')
    higher = document.getElementById('js-higher-value')
    lower.innerHTML = if values[0] > 18 then '18+' else Math.round(values[0]) + 'j.'
    higher.innerHTML = if values[1] > 18 then '18+' else Math.round(values[1]) + 'j.'

  $(document).on
    click: (e)->
      $('.js-seeker-delete-icon').removeClass('display-none')
      $('.js-age-slider-container').removeClass('opacity-0')
    '.js-search-field-seeker'

  $(document).on
    click: (e)->
      $('.js-age-slider-container').addClass('opacity-0')
      window.seekersList.filter()
    '.js-seeker-delete-icon'

