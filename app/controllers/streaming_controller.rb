require "#{Rails.root.join('lib', 'application', 'sse')}"
require "#{Rails.root.join('lib', 'application', 'notifications')}"

class StreamingController < ApplicationController
  if Mtheory::DecksterConfiguration.streaming
    include ActionController::Live

    def notifications
      last_id = request.headers['last-event-id'] ? request.headers['last-event-id'].to_i : 0
      response.headers['Content-Type'] = 'text/event-stream'

      sse = SSE.new response.stream
      notification_connection = NotificationConnectionPool.add Thread.current[:username], last_id

      while (notification = notification_connection.queue.pop) do
        sse.write(notification.obj, id: notification.id, event: :notification)
      end
    rescue IOError
      puts "Experienced IOError, probably loss of connection"
    ensure
      sse.close
      NotificationConnectionPool.remove(notification_connection)
    end
  else
    def notifications
      render nothing: true
    end
  end

  # true if streaming is on, false if it is off
  def check_status
    render text: Mtheory::DecksterConfiguration.streaming.to_s
  end
end