Polymer 'lancie-commission',
  commission: null

  ###
    Start on DOM loaded
  ###
  ready: ->
    
  ###
    Insert ajax response into variable commission
  ###
  loadedJSON: (event) ->
    @commission = event.currentTarget.response
  