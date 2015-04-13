Polymer 'create-account',

  ###
    Set all variables to null, so the api always get all the data it needs
  ###
  userhash: null
  userId: null
  emailcode: null
  userPayed: false
  person: {}

  ###
    Initial of elements
  ###
  ready: ->
    @person = JSON.parse localStorage.getItem("lancie-create-account-save")
    @loadLocalstorage()

    # Load confirm page
    params = @getUrlParams()
    if params.confirm && @person? 
      @$.animatedpages.selected = 4
      @$.progress.value = 100
      @$.userPayed.go()
    else if params.payment && @person? && params.code?
      @$.animatedpages.selected = 3
      @$.verification.value = params.code
      @$.getUserById.go()
    else if params.payment
      @$.animatedpages.selected = 3
      @$.progress.value = 80
      @userhash = params.hash
      @$.getUserByHash.go()

  userPayedLoaded: ->
    if @$.userPayed.response is true
      @userPayed = true
    else 
      @userPayed = false
    @person = null
    @$.lancieCreateAccountSave.save()

  getUserByHashLoaded: ->
    @userId = @$.getUserByHash.response
    @$.getUserById.go()
    @$.getProfileById.go()

  getUserByIdLoaded: ->
    callback = @$.getUserById.response
    @username = callback.username
    @email = callback.email
    @chmember = callback.chmember
    @transport = callback.transport
    @emailcode = callback.hash.substr(callback.hash.length - 8, 8)

  getProfileByIdLoaded: ->
    callback = @$.getProfileById.response
    @name = callback.name
    @surname = callback.surname
    
    @zipcode = callback.zipcode
    @address = callback.address
    @city = callback.city
    @tel = callback.tel
    @notes = callback.notes
    @saveData()


  getUrlParams: ->
    qs = document.location.search.split('+').join(' ')
    params = {}
    tokens = undefined
    re = /[?&]?([^=]+)=([^&]*)/g
    while tokens = re.exec(qs)
      params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2]);
    return params

  ###

  ###
  loadLocalstorage: ->
    try
      @username = @person.account.username
      @password = @cpassword = @person.account.password
      @email = @person.account.email
      @userId = @person.account.userId
      @chmember = @person.account.chmember

      @name = @person.profile.name
      @initials = @person.profile.initials
      @surname = @person.profile.surname
      @gender = @person.profile.gender == "f" ? true : false
      @zipcode = @person.profile.zipcode
      @number = @person.profile.number
      @tel = @person.profile.tel
      @notes = @person.profile.notes
      @$.autoCompleteAddress.go()

      @transport = @person.account.transport
    catch error
      @person = null

  ###

  ###
  onTapTerms: ->
    @$.agreement.toggle()

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

  verifyEmail: ->
    @emailEncoded = encodeURIComponent(@email)
    @$.verfyEmail.go()

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

  ###
  saveData: (e) ->
    genderChar = if @gender then "f" else "m"
    @person = if @person is null then {} else @person
    @person.account = {
      username: @username
      email: @email
      password: @password
    }
    @person.profile = {
      name: @name 
      initials: @initials
      surname: @surname
      gender: genderChar
      chmember: @chmember
      transport: @transport
      address: @address + " " + @number
      number: @number
      zipcode: @zipcode
      city: @city
      tel: @tel
      notes: @notes
    }
    @$.lancieCreateAccountSave.save()

  ###
    AJAX Request to insert an user into the database
  ###
  insertUser: ->
    @$.insertUser.params = @mergeInto(@person.account, @person.profile)
    @$.insertUser.go()

  ###

  ###
  callbackUserInsert: ->
    callback = JSON.parse @$.insertUser.response
    @emailcode = callback.code
    @userId = callback.userId
    @person.account.userId = @userId
    @$.lancieCreateAccountSave.save()

  ###

  ###
  payNow: ->
    @$.getPaymentUrl.go()

  redirUser: ->
    window.location = @$.getPaymentUrl.response

  ###

  ###
  mergeInto: (o1, o2) ->
    if o1 == null or o2 == null
      return o1
    for key of o2
      if o2.hasOwnProperty(key)
        o1[key] = o2[key]
    o1

