Polymer 'lancie-login-form',

  ready: ->

  handleResponse: ->
    callback = @$.loginAJAX.response
    console.log callback
    if callback.status.code is 200
      @$.username.isInValid = @$.password.isInValid = false
      @userdata = callback.details
      window.location = '/myarea/'
    else
      @$.username.error = 'Username and password do not match!'
      @$.password.error = 'Username and password do not match!'
      @$.username.isInValid = @$.password.isInValid = true

  submit: ->
    @$.loginAJAX.go()

  show: ->
    @$.loginForm.toggle()