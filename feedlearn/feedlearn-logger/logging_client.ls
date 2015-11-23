root = exports ? this

{getvar, get-user-name} = root # commonlib.ls

export post-start-event = (eventname) ->
  post-json '/settimestampforuserevent', {username: get-user-name(), eventname: eventname}



