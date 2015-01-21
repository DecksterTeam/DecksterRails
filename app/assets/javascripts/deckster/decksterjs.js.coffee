###*
  This is a helper function to trigger the specified event on a given element
  @param {el} The element to trigger the event on
  @param {event} The event to trigger
###
trigger_event = (el, event) ->
  $(el).trigger(event)

###*
  This function will load content of specified type into the card
  @param {card_el} The card element that is the parent of the summary and detail sections
  @param {type} The section of the card that you would like to load (summary or detail)
###
load_card_content = (card_el, type, reload_card = false) ->
  $card_el = $(card_el)
  $card_content_el = $card_el.find(".deckster-content > .deckster-#{type}")
  card_content_loaded = $card_content_el.attr 'data-content-loaded'

  if card_content_loaded == false || card_content_loaded == 'false' || reload_card
    $card_content_el.html('Loading ...') if reload_card

    card_content_loaded_url = $card_content_el.attr "data-#{type}-url"
    if card_content_loaded_url?
      on_response = (response) ->
        $card_content_el.html response
        $card_content_el.attr 'data-content-loaded', true
        trigger_event($card_el, "deckster.card-#{type}.loaded")
        setupPopover() if $card_el.context.id == 'streamers'
      $.get card_content_loaded_url, on_response, 'html'

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
  extendPopover()

  gridster.$widgets.each () ->
    $widget = $(this)
    load_card_content $widget, 'summary'

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
      $card_content_summary.fadeIn({complete: trigger_event($widget, 'deckster.card-summary.shown')})
    else
      $widget.attr 'data-expanded', true
      gridster.expand_widget $widget, 4 #TODO should this be set to the max number of columns in the grid
      $widget.find('.deckster-expand-handle').hide()
      $widget.find('.deckster-popout-handle').show()
      $widget.find('.deckster-refresh-handle').show()
      $widget.find('.deckster-collapse-handle').show()

      $card_content = $widget.children '.deckster-content'
      $card_content_summary = $card_content.children '.deckster-summary'
      $card_content_detail = $card_content.children '.deckster-detail'
      
      #console.log [$card_content_summary, $card_content_detail]

      $card_content_summary.fadeOut()
      $card_content_detail.fadeIn({complete: trigger_event($widget, 'deckster.card-detail.shown')});

      load_card_content $widget, 'detail'

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
#    card_type = if is_expanded then 'detail' else 'summary'

  card_types = ['detail', 'summary']
  for card_type in card_types
    load_card_content $widget, card_type, true

refreshDeck = () ->
  $('.deckster-card').each( (index, value)-> refreshCard($(value)) )

setupCardSearch = () ->
  seen_values = []
  $('.deckster-card').each (index, value) ->
    val = $(value).data("title")
    if seen_values.indexOf(val) == -1
      $('#deck_controls_title_search')
      .append($("<option></option>", {
          value: val,
          text: val
        }))
      seen_values.push val

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

refreshCardSearch = () ->
  $('#deck_controls_title_search').html("<option></option>")
  setupCardSearch()

setupPopover = () ->
  $('#popover_example').popover({url: '/deckster/card/balloons_summary', params: {layout: false, a:1, b:2}, title: "Title!", popoverId: '#popover_example'})

extendPopover = () ->
  tmp = $.fn.popover.Constructor.prototype.show;

  $.fn.popover.Constructor.prototype.show = () ->
    if (this.options.url and this.options.popoverId)
      url = this.options.url
      popoverId = this.options.popoverId
      params = this.options.params if this.options.params
      this.options.content = "Loading..."

    tmp.call(this);

    if (this.options.url and this.options.popoverId)
      on_response = (data) ->
        #I find this line slightly hacky. It assumes that bootstrap will always generate the popover
        #div and contents immediately after where it is declared. While this is true now, it may not
        #be true forever
        $(popoverId).next().find('.popover-content').html(data)
      $.get url, params, on_response, 'html'

window.decksterjs =
  init: init
  refreshDeck: refreshDeck
  refreshCardSearch: refreshCardSearch
  setupPopover: setupPopover
  extendPopover: extendPopover
