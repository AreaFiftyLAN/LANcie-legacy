Polymer 'lancie-seatmap',
  seats: null
  userhash: "AREA51LAN554113EBCB7F4"
  
  ready: ->
    @.addEventListener 'lancie-seatmap-seat-tap', (event) =>
      @currentNode.toggle() unless @currentNode is null or event.path[0].mode is "occupied"
      @currentNode = event.path[0] unless event.path[0].mode is "occupied"

    @.addEventListener 'lancie-seatmap-reserve', (event) =>
      @seatid = event.detail.data.seatid
      @$.reserveSeatAJAX.go()

  ###

  ###
  numberToChar: (i) ->
    return String.fromCharCode(65 + i)

  ###

  ### 
  updateMap: ->
    @$.getAllSeatsAJAX.go()

  ###

  ###
  loadedJSON: ->
    @seats = @$.getAllSeatsAJAX.response
