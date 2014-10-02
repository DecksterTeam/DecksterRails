# About these classes:
# Notification and NotificationStore are used by code that needs to provide a User with a notification.
# StreamingController uses NotificationConnectionPool to create & destroy NotificationConnections.
# StreamingController reads from a NotificationConnection's queue to emit SSEs.
# To send a notification to all tabs opened by one user:
#   NotificationStore.add username, Notification.new({ message: 'Your notification has arrived!' })

# represents one notification; obj can be any serializable object
class Notification
  attr_accessor :obj, :id

  def initialize obj
    @obj, @id = obj, Time.now.to_i
  end
end

# management of UserNotifications
module NotificationStore
  @notifications = ThreadSafe::Hash.new

  # add a notification for a user and send to all active connections
  def self.add username, notification
    @notifications[username] ||= ThreadSafe::Array.new
    @notifications[username].push(notification)

    NotificationConnectionPool.send_notification username, notification
  end

  # get all notifications for a user that have an id greater than after_id
  def self.get username, after_id = 0
    return [] unless @notifications[username]
    @notifications[username].select{ |m| m.id > after_id }.sort{ |a,b| b.id <=> a.id }
  end
end

# holds a queue that feeds an SSE emitter
class NotificationConnection
  attr_accessor :username, :queue

  def initialize username
    @username, @queue = username, Queue.new
  end
end

# holds the pool of NotificationConnections, organized by user
module NotificationConnectionPool
  @pool = ThreadSafe::Hash.new

  # add a connection
  def self.add username, last_id = 0
    notification_connection = NotificationConnection.new username

    @pool[username] ||= ThreadSafe::Array.new
    @pool[username].push(notification_connection)

    # enqueue unseen notifications
    NotificationStore.get(username, last_id).each do |notification|
      notification_connection.queue.push notification
    end

    notification_connection
  end

  # send notification to all connections that belong to a user
  def self.send_notification username, notification
    @pool[username].each do |notification_connection|
      notification_connection.queue.push notification
    end
  end

  # remove a connection
  def self.remove notification_connection
    @pool[notification_connection.username].delete(notification_connection)
  end
end