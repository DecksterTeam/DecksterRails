# cheap FIFO implementation of background tasks
module BackgroundJobs
  @@task_queue = Queue.new

  def self.enqueue username, function_name, params
    proc = case function_name
    when :notify
      Proc.new {
        sleep(5)
        NotificationStore.add username, Notification.new({ message: 'Your notification has arrived!' })
      }
    else
      nil
    end
    
    @@task_queue.push({ username: username, proc: proc }) unless proc.nil?
  end

  # worker thread
  Thread.new do
    while true do
      # Queue#pop will sleep the current thread until the queue is not empty
      @@task_queue.pop[:proc].call()
    end
  end
end