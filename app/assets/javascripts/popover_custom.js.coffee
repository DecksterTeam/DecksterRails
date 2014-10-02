$(document).ready ->
  popoverIndex = 0

  $(window).on 'DOMSubtreeModified', ->
    newCount = 0

    $('[data-toggle~=popover]').each (index, element) =>
      # assign each popover trigger a unique ID if it doesn't already have one, maintaing count between DOM modifications
      if ($(element).data('popover-id') == undefined)
        $(element).popover({
          selector: '[data-toggle~=popover]',
          trigger: 'manual',
        }).unbind 'hover'

        $(element).data('popover-id', 'popover-' + (popoverIndex + index))

        $(element).on 'mouseenter', ->
          showPopover index, element, $(element).attr('data-placement')

        $(element).on 'mouseleave', ->
          hidePopover index, element

        $(element).on 'click', ->
          hidePopoverImm index, element

        newCount += 1

    popoverIndex += newCount

cancelHideAction = (index, element) ->
  $.doTimeout 'popover_hide' + index

hidePopover = (index, element) ->
  $.doTimeout 'popover_show' + index
  $.doTimeout 'popover_hide' + index, 250, ->
    $("#" + $(element).data('popover-id')).fadeOut(100)

hidePopoverImm = (index, element) ->
  $.doTimeout 'popover_show' + index
  $.doTimeout 'popover_hide' + index
  $("#" + $(element).data('popover-id')).fadeOut(100)

showPopover = (index, element, positionModification) ->
  $.doTimeout 'popover_show' + index, 250, ->
    popoverElt = $("#" + $(element).data('popover-id'))
    pos = $(element).offset() # record the triggering element's coordinates
    if ($(popoverElt).length > 0)
      # find difference in position
      heightDiff = $(element).offset().top - $(element).data('originalTop')
      $(popoverElt).css('margin-top', heightDiff)
      $(popoverElt).fadeIn(100)
    else
      $(element).popover 'show' # show popover
      popoverElt = $("div.popover:not([id])") # find new popover
      popoverElt.attr('id', $(element).data('popover-id')) # assign it its ID

    $('.popover-content').on 'mouseenter', ->
      cancelHideAction index, element
    $('.popover-content').on 'mouseleave', ->
      hidePopover index, element
