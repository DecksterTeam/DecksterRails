namespace = 'DEBUG: '

debug = (message) ->
  if console && console.log
    if typeof(message) == 'string'
      console.log namespace + message
    else
      console.log namespace + '(object below)'
      console.log message

get_time = -> return new Date().getTime()

time = (message, start_time) ->
  console.log(namespace + message + ' => ' + (get_time() - start_time) + 'ms') if console && console.log

window.SafeDebug = {
  namespace: namespace,
  debug: debug,
  get_time: get_time,
  time: time
}

window._debugger = window.SafeDebug