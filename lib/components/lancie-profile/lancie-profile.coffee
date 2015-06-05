Polymer 'lancie-profile',
  
  ready: ->

  loadedJSON: (e) ->
    callback = e.currentTarget.response
    if callback.status.code is 470
      window.location = "/"
