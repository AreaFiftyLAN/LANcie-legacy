Polymer 'commission-members',
  memberList: null

  ready: ->
    @$.membersJSON.addEventListener 'core-response', (callback) =>
      @memberList = callback.detail.response