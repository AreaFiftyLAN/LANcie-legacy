Polymer 'create-account',

  ###
    Set all variables to null, so the api always get all the data it needs
  ###
  userhash: null
  userId: null
  emailcode: null
  userPayed: false
  price_ticket: null
  price_transport: null
  price_total: null
  dates: null
  person: {}

  ###
    Initial of elements
  ###
  ready: ->
    # Load confirm page
    params = @getUrlParams()
    @userhash = params.hash

    @person = null
    @$.lancieCreateAccountSave.save()

    if params.confirm
      @$.animatedpages.selected = 5
      @$.progress.value = 100
      @$.getAccountByHash.go(true)
    else if params.payment 
      @$.animatedpages.selected = 4
      @$.progress.value = 80
      @$.emailcode = @$.verification.value = @userhash.substring(@userhash.length - 4, @userhash.length)
      @$.getAccountByHash.go()

  userPaid: ->
    callback = @$.getPaymentUser.response
    console.log callback
    if callback.details.paid is true
      @userPaid = true
    else 
      @userPaid = false
    @person = null
    @$.lancieCreateAccountSave.save()


  getAccountByHashLoaded: (flag = false) ->
    callback = @$.getAccountByHash.response
    @getAccount(callback.details.account)
    @getProfile(callback.details.profile)
    if flag then @$.getPaymentUser.go()
    @getPrice()



  getAccount: (account) ->
    @userId = account.id
    @username = account.username
    @email = account.email
    @chmember = account.chmember
    @transport = account.transport
    @tickettype = account.tickettype
    @emailcode = account.hash.substr(account.hash.length - 4, 4)
    @verifyEmail()


  getProfile: (profile) ->
    @name = profile.name
    @surname = profile.surname
    @zipcode = profile.zipcode
    @address = profile.address
    @city = profile.city
    @tel = profile.tel
    @notes = profile.notes
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

  emailcheckToggle: ->
    @$.emailcheck.toggle()

  ###

  ###
  runEmailCheck: ->
    @$.checkEmailAJAX.go()

  ###

  ###
  runUsernameCheck: ->
    @$.checkUsernameAJAX.go()

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
      if @$.checkUsernameAJAX.response.details.exists is true
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
    # target = undefined #
    if !e.currentTarget.isEmpty
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      target = @$.email
      if !re.test(target.value)
        target.error = 'Please fill in a valid email address!'
        return target.isInValid = true
      else if @$.checkEmailAJAX.response.details.exists is true
        console.log "HALLO!"
        target.error = 'This email is already taken, please choose another!'
        return target.isInValid = true
      else
        return target.isInValid = false

  ###

  ###
  checkPhone: (e) ->
    if !e.currentTarget.isInvalid
      target = e.currentTarget
      value = target.value.replace(/[^0-9]/g, '');
      if value.length != 0
        target.error = 'Your phone number is invalid, please check if it is 10 digit long!'
        return target.isInvalid = true
      else 
        return target.isInvalid = false

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
      @zipcode = @zipcode.replace(/\s+/, "") 
      @number = @number.replace(/\s+/, "")
      @$.autoCompleteAddress.go()
      
  ###

  ###
  autoCompleteAddress: ->
    callback = @$.autoCompleteAddress.response
    if callback.success is true
      result = callback.resource
      @address = result.street
      @city = result.town
    else
      @$.zipcodeDecorator.error = 'Please fill in a valid zipcode (1000AA)!'
      @$.numberDecorator.error = 'Please fill in a valid house number!'
      return @$.numberDecorator.isInvalid = @$.zipcodeDecorator.isInvalid = true

  ###

  ###
  saveData: (e) ->
    genderChar = if @gender then "f" else "m"
    @person = if @person is null then {} else @person
    @person.account = {
      username: @username
      email: @email
      password: @password
      tickettype: @tickettype
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
    console.log @$.lancieCreateAccountSave.value

  ###

  ###
  changeTicketType: (e) ->
    @tickettype = e.currentTarget.dataset.ticket
    @saveData()

  ###
    AJAX Request to insert an user into the database
  ###
  createAccount: ->
    @$.createAccount.params = @mergeInto(@person.account, @person.profile)
    @$.createAccount.go()

  ###

  ###
  callbackUserInsert: ->
    callback = @$.createAccount.response
    console.log callback
    if callback.status.code is 471 || callback.status.code is 472
      @runUsernameCheck()
      @runEmailCheck()
      @$.animatedpages.selected = 1
      @$.progress.value = 20
    else if callback.status.code is 201
      @emailcode = callback.details.code
      @userId = callback.details.userId
      @person.account.userId = @userId
      @$.lancieCreateAccountSave.save()
      @$.animatedpages.selected = 4
      @$.progress.value = 60

  ###

  ###
  payNow: ->
    @$.getPaymentUrl.go()

  ###

  ###
  redirUser: ->
    window.location = @$.getPaymentUrl.response.details

  ###

  ###
  getPrice: ->
    price = 0.00
    if @tickettype isnt "area_003"
      price += 17.50
      if @chmember is false
        price += 2.50
    else
      price += 30.00
      if @chmember is false
        price += 5.00
    @price_ticket = price.toFixed(2)

    if @transport is true
      @price_transport = 2.50.toFixed(2)
    else
      @price_transport = 0.00

    @price_total = (parseFloat(@price_ticket) + parseFloat(@price_transport)).toFixed(2)

    if @tickettype is "area_001"
      @dates = "12/13"
    else if @tickettype is "area_002"
      @dates = "13/14"
    else
      @dates = "12/13/14"

  ###

  ###
  mergeInto: (o1, o2) ->
    if o1 == null or o2 == null
      return o1
    for key of o2
      if o2.hasOwnProperty(key)
        o1[key] = o2[key]
    o1

