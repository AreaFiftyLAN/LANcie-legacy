Polymer 'preregistration-element',
  name: null
  email: null

  ready: ->
    @$.preregistrationAJAX.addEventListener 'core-response', (callback) =>
      if callback.detail.response == 'Entry saved'
        @$.submitToast.text = 'You have succesfully pre-registered. Thank you!'
        @$.submitToast.show()
        @$.name = @.email = ''
      else
        if callback.detail.response.indexOf('Duplicate') != -1
          @$.submitToast.text = 'This emailaddress has already been registered! Please fill in another emailaddress.'
          @$.submitToast.show()
        else
          @$.submitToast.text = 'Something went wrong! Please try again.'
          @$.submitToast.show()

  submit: ->
    if @checkEmptyTarget(@$.name) and @checkEmptyTarget(@$.email) and @checkEmail()
      @$.preregistrationAJAX.go()
    return

  checkEmptyTarget: (target) ->
    element = target.currentTarget or target
    decElement = @getDecorator(element)
    if element.value == undefined or element.value == ''
      element.error = 'Please fill in this input!'
      decElement.isInvalid = element.isEmpty = true
      return false
    decElement.isInvalid = element.isEmpty = false
    true

  checkEmail: ->
    email = @$.email
    decEmail = @getDecorator(email)

    ### Break if email is empty ###

    if email.isEmpty
      return

    ### Check if email is valid ###

    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    if !re.test(email.value)
      email.error = 'Please fill in a valid email address!'
      decEmail.isInvalid = true
      return false
    decEmail.isInvalid = false
    true

  getDecorator: (element) ->
    element.shadowRoot.querySelector 'paper-input-decorator'