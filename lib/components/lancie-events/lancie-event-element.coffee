Polymer 'lancie-event-element',

  ###
    Start on DOM loaded
  ###
  ready: ->

  ###
    Toggle paper-action-dialog with more information about this event
  ###
  openActionDialog: ->
    @$.paperAction.toggle()