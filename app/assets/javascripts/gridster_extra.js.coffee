init = () ->
  gridster_options =
    widget_margins: [10, 10]
    widget_base_dimensions: [300, 115]
    #min_cols: 4
    #max_cols: 4
    #max_size_x: 4
    #helper: 'clone'
    draggable:
      handle: '.deckster-card-title'

  gridster = $(".gridster").gridster(gridster_options).data 'gridster'

  gridster.$el.on 'click', '> li > .deckster-controls > .deckster-expand-handle', () ->
    $button = $(this)
    $widget = $button.parents 'li'
    $is_expanded = $widget.attr 'data-expanded'

    if $is_expanded? && $is_expanded == 'true'
      $widget.attr 'data-expanded', false
      gridster.collapse_widget $widget
      $widget.find('.deckster-popout-handle').hide()

      $card_content = $widget.children '.content'
      $card_content_summary = $card_content.children '.summary'
      $card_content_detail = $card_content.children '.detail'

      $card_content_detail.fadeOut()
      $card_content_summary.fadeIn()
    else
      $widget.attr 'data-expanded', true
      gridster.expand_widget $widget, 4
      $widget.find('.deckster-popout-handle').show()

      $card_content = $widget.children '.content'
      $card_content_summary = $card_content.children '.summary'
      $card_content_detail = $card_content.children '.detail'

      $card_content_summary.fadeOut()
      $card_content_detail.fadeIn();

      card_content_detail_loaded = $card_content_detail.attr 'data-content-loaded'
      card_content_detail_loaded ?= false
      if card_content_detail_loaded == false
        card_content_detail_loaded_url = $card_content_detail.attr 'data-detail-url'
        if card_content_detail_loaded_url?
          on_response = (response) ->
            $card_content_detail.html response
            $card_content_detail.attr 'data-content-loaded', true
          $.get card_content_detail_loaded_url, on_response, 'html'

  gridster.$el.on 'click', '> li > .deckster-controls > .deckster-popout-handle', () ->
    $button = $(this)
    $widget = $button.parents 'li'

    url = $widget.find('.detail').attr('data-detail-url')
    title = $widget.attr 'data-title'
    window.open(url + '&popout=true&title=' + title, '_blank').focus()


window.gridster_extra =
  init: init
