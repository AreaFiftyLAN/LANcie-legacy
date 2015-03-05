Polymer 'section-event',
  eventsList: null

  ready: ->
    @$.eventsAJAX.addEventListener 'core-response', (callback) =>
      @eventsList = callback.detail.response