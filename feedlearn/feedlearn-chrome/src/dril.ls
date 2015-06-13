console.log "uraaaa!"

window.add-event-listener 'message', (e) ->
    console.log e
    console.log e.data
    console.log e.origin
    m = e.data
    if m? and m.dril == 'reformat'
        console.log 'reformat'
        add-style!

add-style = ->
    cb = ->
        l = document.createElement('link')
                ..rel = 'stylesheet'
                ..href = chrome.extension.getURL 'dril.css'
        h = document.getElementsByTagName('head')[0]
                ..parentNode.insertBefore(l, h)
    raf = requestAnimationFrame || mozRequestAnimationFrame || webkitRequestAnimationFrame || msRequestAnimationFrame
    if (raf)
       raf(cb)
    else
       window.addEventListener('load', cb) # TODO: ???

main = ->
    msg = {feedlearn: 'loaded'}
    window.parent.postMessage msg, '*'

main!

#window.set-timeout ->
#    console.log 'TIMEOUT!!!'
#    main!
#, 5000

#add-style!