Polymer 'sponsors-element',
  sponsorsList: null
  
  ready: ->
    @$.sponsorsAJAX.addEventListener 'core-response', (callback) =>
      @sponsorsList = callback.detail.response