Polymer 'section-tournaments',
  tournamentsList: null

  ready: ->
    @$.tournamentsAJAX.addEventListener 'core-response', (callback) =>
      @tournamentsList = callback.detail.response

  onTapTournament: (e, d, s) ->
    s.querySelector('paper-action-dialog').toggle()