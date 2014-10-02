$(document).on 'ready', () ->
  $.get '/streaming/check_status', (data, textStatus, jqXHR) ->
    if data == 'true'
      notification_source = new EventSource('/streaming/notifications')
      notification_source.addEventListener 'notification', (evt) ->
        console.log(evt)
        message = JSON.parse(evt.data)