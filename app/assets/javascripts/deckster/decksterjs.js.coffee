init = (custom_opts={}) ->
  gridster_options =
    widget_selector: '.deckster-card'
    widget_margins: [10, 10]
    widget_base_dimensions: [300, 300]
    autogenerate_stylesheet: true
    #min_cols: 4
    #max_cols: 4
    #max_size_x: 4
    #helper: 'clone'
    draggable:
      handle: '.deckster-card-title, .deckster-card-draggable'

  $.extend(gridster_options, custom_opts)

  gridster = $(".gridster").gridster(gridster_options).data 'gridster'

  window.grid = gridster

  setupCardSearch()

  gridster.$widgets.each () ->
    $widget = $(this)
    $card_content_summary = $widget.find('.deckster-content > .deckster-summary')
    card_content_summary_loaded = $card_content_summary.attr 'data-content-loaded'
    if card_content_summary_loaded == false || card_content_summary_loaded == 'false'
      card_content_summary_loaded_url = $card_content_summary.attr 'data-summary-url'
      if card_content_summary_loaded_url?
        on_response = (response) ->
          $card_content_summary.html response
          $card_content_summary.attr 'data-content-loaded', true
        $.get card_content_summary_loaded_url, on_response, 'html'

  gridster.$el.on 'click', '> .deckster-card .deckster-controls .deckster-expand-collapse-handle', () ->
    $button = $(this)
    $widget = $button.parents '.deckster-card'
    $is_expanded = $widget.attr 'data-expanded'

    if $is_expanded? && $is_expanded == 'true'
      $widget.attr 'data-expanded', false
      gridster.collapse_widget $widget
      $widget.find('.deckster-expand-handle').show()
      $widget.find('.deckster-popout-handle').hide()
      $widget.find('.deckster-refresh-handle').hide()
      $widget.find('.deckster-collapse-handle').hide()

      $card_content = $widget.children '.deckster-content'
      $card_content_summary = $card_content.children '.deckster-summary'
      $card_content_detail = $card_content.children '.deckster-detail'

      $card_content_detail.fadeOut()
      $card_content_summary.fadeIn()
    else
      $widget.attr 'data-expanded', true
      gridster.expand_widget $widget, 4
      $widget.find('.deckster-expand-handle').hide()
      $widget.find('.deckster-popout-handle').show()
      $widget.find('.deckster-refresh-handle').show()
      $widget.find('.deckster-collapse-handle').show()

      $card_content = $widget.children '.deckster-content'
      $card_content_summary = $card_content.children '.deckster-summary'
      $card_content_detail = $card_content.children '.deckster-detail'
      
      console.log [$card_content_summary, $card_content_detail]

      $card_content_summary.fadeOut()
      $card_content_detail.fadeIn();

      card_content_detail_loaded = $card_content_detail.attr 'data-content-loaded'
      card_content_detail_loaded ?= false
      if card_content_detail_loaded == false || card_content_detail_loaded == 'false'
        card_content_detail_loaded_url = $card_content_detail.attr 'data-detail-url'
        if card_content_detail_loaded_url?
          on_response = (response) ->
            $card_content_detail.html response
            $card_content_detail.attr 'data-content-loaded', true
          $.get card_content_detail_loaded_url, on_response, 'html'

  gridster.$el.on 'click', '> .deckster-card .deckster-controls .deckster-popout-handle', () ->
    $button = $(this)
    $widget = $button.parents '.deckster-card'

    url = $widget.find('.deckster-detail').attr('data-detail-url')
    console.log url

  gridster.$el.on 'click', '> .deckster-card .deckster-controls .deckster-refresh-handle', () ->
    $button = $(this)
    $widget = $button.parents '.deckster-card'
    refreshCard($widget)

refreshCard = ($widget) ->
#    USE THIS IF YOU ONLY WANT TO REFRESH ONE VIEW INSTEAD OF BOTH
#    is_expanded = $widget.attr 'data-expanded'
#    $card_type = if is_expanded then 'detail' else 'summary'

  card_types = ['detail', 'summary']
  for card_type in card_types
    card_content_obj = $widget.find(".deckster-content > .deckster-#{card_type}")
    card_content_url = card_content_obj.attr "data-#{card_type}-url"

    if card_content_url?
      on_response = (response) ->
        card = this
        card.html response
        card.attr 'data-content-loaded', true
      $.get card_content_url, $.proxy(on_response, card_content_obj), 'html'

refreshDeck = () ->
  $('.deckster-card').each( (index, value)-> refreshCard($(value)) )

setupCardSearch = () ->
  $('.deckster-card').each (index, value) ->
    val = $(value).data("title")
    $('#deck_controls_title_search')
    .append($("<option></option>", {
        value: val,
        text: val
      }))

  $('#deck_controls_title_search').chosen().change(() ->
    value = $(this).val()
    card = $(".deckster-card[data-title='#{value}']")

    #scroll to the card
    $('html,body').animate({scrollTop: card.offset().top-10 })

    #highlight card briefly
    card.addClass("selected")
    callback = () -> card.removeClass("selected")
    setTimeout(callback, 2000)
  )

window.decksterjs =
  init: init
  refreshDeck: refreshDeck
  setupCardSearch: setupCardSearch
