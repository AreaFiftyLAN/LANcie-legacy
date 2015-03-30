Polymer 'create-account',

  ###
    Set all variables to null, so the api always get all the data it needs
  ###
  userhash: null
  userId: null
  username: null
  email: null
  password: null
  cpassword: null
  name: null
  initials: null
  surname: null
  gender: null
  chmember: null
  transport: null
  address: null
  number: null
  zipcode: null
  city: null
  tel: null
  notes: null

  ###
    Initial of elements
  ###
  ready: ->
    qs = document.location.search.split('+').join(' ')
    params = {}
    tokens = undefined
    re = /[?&]?([^=]+)/g
    while tokens = re.exec(qs)
      params[decodeURIComponent(tokens[1])] = true
    if params.payment
      @$.animatedpages.selected = 3
      @$.progress.value = 80
    if params.confirm
      @$.animatedpages.selected = 4
      @$.progress.value = 100

  ###
    Brings you to the next page and changes the progressbar
  ###
  pageNext: ->
    if @$.animatedpages.selected < 3
      return (@$.animatedpages.selected += 1) and (@$.progress.value += 20)

  ###
    Brings you to the prev page and changes the progressbar
  ###
  pagePrev: ->
    if @$.animatedpages.selected > 0
      return (@$.animatedpages.selected -= 1) and (@$.progress.value -= 20)

  ###
    Checks iff an username isn't already in the database 
      else it will activate the inValid flag of the inputbox
  ###
  checkUsername: (e) ->
    if !e.currentTarget.isEmpty
      target = @$.username
      if @$.checkUsernameAJAX.response is true
        target.error = 'This username is already taken, please choose another!'
        return target.isInValid = true
      else
        return target.isInValid = false

  ###
    Checks iff the password isnt the same as the username
      else it will activate the inValid flag of the inputbox
  ###
  checkPassword: (e) ->
    if !e.currentTarget.isEmpty
      target = e.currentTarget
      if target.value == @$.username.value
        target.error = 'Your password can\'t be the same as your username!'
        return target.isInValid = true
      else
        return target.isInValid = false

  ### 
    Checks iff password and confirm password are the same
      else it will activate the inValid flag of the inputbox
  ###
  checkConfirmPassword: (e) ->
    if !e.currentTarget.isEmpty and @$.password.isValid
      target = e.currentTarget
      if target.value != @$.password.value
        target.error = 'Please fill in the same passwords!'
        return target.isInValid = true
      else
        return target.isInValid = false

  ###
    Check iff an email address if valid
      it uses the regex designed by google
      else it will activate the inValid flag  of the inputbox
  ###
  checkEmail: (e) ->
    re = undefined
    target = undefined
    if !e.currentTarget.isEmpty
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      target = e.currentTarget
      if !re.test(target.value) 
        target.error = 'Please fill in a valid email address!'
        return target.isInValid = true
      else if @$.checkEmailAJAX.response is true
        target.error = 'This email is already taken, please choose another!'
        return target.isInValid = true
      else
        return target.isInValid = false

  ###

  ###
  emptyCheck: (e) ->
    if !e.currentTarget.isEmpty
      target = e.currentTarget
      if target.value is ""
        target.parentNode.error =  target.parentNode.label + ' cannot be empty!'
        target.parentNode.isInvalid = true
      else
        target.parentNode.isInvalid = false

  ###
    autoCompleteAddress
  ###
  getAddress: (e) ->
    if e.currentTarget is @$.zipcode 
      if not @zipcode?
        @$.zipcodeDecorator.error = 'Zipcode cannot be empty!'
        @$.zipcodeDecorator.isInvalid = true
      else 
        @$.zipcodeDecorator.isInvalid = false

    if e.currentTarget is @$.number 
      if not @number?
        @$.numberDecorator.error = 'House number cannot be empty!'
        @$.numberDecorator.isInvalid = true
      else 
        @$.numberDecorator.isInvalid = false

    if @zipcode? and @number?
      @$.zipcodeDecorator.isInvalid = @$.numberDecorator.isInvalid = false
      @$.autoCompleteAddress.go()
      
  ###

  ###
  autoCompleteAddress: ->
    callback = @$.autoCompleteAddress.response
    if callback.status is "ok"
      result = callback.details[0]
      @address = result.street
      @city = result.city
    else 
      @address = @city = null
      if callback.errormessage.indexOf('postcode') isnt -1
        @$.zipcodeDecorator.error = 'Please fill in a valid zipcode (1000AA)!'
        return @$.zipcodeDecorator.isInvalid = true
      else
        @$.zipcodeDecorator.isInvalid = false

      if callback.errormessage.indexOf('number') isnt -1
        @$.numberDecorator.error = 'Please fill in a valid house number!'
        return @$.numberDecorator.isInvalid = true
      else 
        @$.numberDecorator.isInvalid = false

      if callback.errormessage.indexOf('results') isnt -1
        @$.zipcodeDecorator.error = @$.numberDecorator.error = 'Please fill in a valid address!'
        return @$.zipcodeDecorator.isInvalid = @$.numberDecorator.isInvalid = true

  ###
    AJAX Request to insert an user into the database
  ###
  insertUser: ->
    genderChar = if @gender then "f" else "m"
    @$.insertUser.params = {
      username: @username
      email: @email
      password: @password
      name: @name 
      initials: @initials
      surname: @surname
      gender: genderChar
      chmember: @chmember
      transport: @transport
      address: @address + " " + @number
      zipcode: @zipcode
      city: @city
      tel: @tel
      notes: @notes
    }
    @$.insertUser.go()

  ###

  ###
  callbackUserInsert: ->
    console.log @$.insertUser.response
    window.location = @$.insertUser.response

    if not @$.insertUser.response[1]?
      console.log @$.insertUser.response
      window.location = @$.insertUser.response
    else 
      if @$.insertUser.response[1] is 1062
        console.log @$.insertUser.response[2]

