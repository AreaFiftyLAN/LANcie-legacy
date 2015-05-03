Polymer 'lancie-seatmap-map',
  
  currentNode: null

  ###
    
  ###
  ready: ->
    @.addEventListener 'lancie-seatmap-seat-tap', (event) =>
      @currentNode.toggle() unless @currentNode is null or event.path[0].mode is "occupied"
      @currentNode = event.path[0] unless event.path[0].mode is "occupied"
  
  ###

  ###
  selectUp: ->
    @currentNode.previousElementSibling.toggle()
    @currentNode.toggle()
    @currentNode = @currentNode.previousElementSibling

  ###

  ###
  selectDown: ->
    @currentNode.nextElementSibling.toggle()
    @currentNode.toggle()
    @currentNode = @currentNode.nextElementSibling

  ###

  ###
  selectLeft: ->
    console.log "lancie-seatmap-map.selectLeft"
    
  ###

  ###
  selectRight: ->
    console.log "lancie-seatmap-map.selectRight"
