Polymer 'lancie-seatmap-map',
  
  currentNode: null

  ###
    
  ###
  ready: ->
  
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
