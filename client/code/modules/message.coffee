# Example Message Module

# Send a message to the server
exports.send = (text, cb) ->
  if valid(text)
    ss.rpc('chat.sendMessage', text, cb)
  else
    cb(false)


# Private

valid = (text) ->
  text && text.length > 0