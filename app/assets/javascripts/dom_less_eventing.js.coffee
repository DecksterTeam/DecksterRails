_event_hash_map = {}

_debug_prefix = 'DomLessEventing: '

clear = (event_name) ->
  window._debugger.debug _debug_prefix + 'Clearing ' + event_name
  _event_hash_map[event_name] = []

_actual_bind = (event_name, callback_function) ->
  clear(event_name) unless _event_hash_map[event_name]?
  _event_hash_map[event_name].push callback_function

bind = (event_name, callback_function) ->
  throw 'DomLessEventing.bind => event_name is not defined' unless event_name?
  window._debugger.debug _debug_prefix + 'Binding ' + event_name
  throw 'DomLessEventing.bind => callback_function is not defined or is not a funciton' unless callback_function? && callback_function instanceof Function
  if event_name instanceof Array
    _actual_bind(single_event_name, callback_function) for single_event_name in event_name
  else
    _actual_bind(event_name, callback_function)

raise = (event_name, event_params, callback) ->
  throw 'DomLessEventing.raise => event_name is not defined' unless event_name?
  #window._debugger.debug _debug_prefix + 'Raising ' + event_name
  if _event_hash_map[event_name]?
    for callback_function in _event_hash_map[event_name]
      callback_function(event_params)

  callback(event_params) if callback? && callback instanceof Function

window.DomLessEventing = {
  clear: clear,
  bind: bind,
  raise: raise
}

window._events = window.DomLessEventing