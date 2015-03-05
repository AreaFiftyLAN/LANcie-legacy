Polymer 'section-tournaments',
  tournamentsList: null

  ready: ->
    @$.tournamentsAJAX.addEventListener 'core-response', (callback) =>
      @tournamentsList = callback.detail.response