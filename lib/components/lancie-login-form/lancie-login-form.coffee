Polymer 'lancie-login-form',

  ready: ->

  handleRespone: ->
    console.log @$.loginAJAX.response

  sumbit: ->
    @$.loginAJAX.go()

  show: ->
    @$.loginForm.toggle()