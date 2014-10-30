init = () ->
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
      handle: '.deckster-card-title'

  gridster = $(".gridster").gridster(gridster_options).data 'gridster'

  window.grid = gridster

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
    title = $widget.attr 'data-title'
    window.open(url + '&title=' + title, '_blank').focus()


window.decksterjs =
  init: init
