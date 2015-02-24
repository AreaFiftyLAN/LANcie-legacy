Polymer 'create-account',
  userhash: null
  userId: null
  username: "svenpopping-asdigkasdfkasjdf"
  email: "svenpopping@gmail.com"
  password: "drie"
  cpassword: "drie"
  name: "Sven"
  initials: "S"
  surname: "Popping"
  gender: false
  chmember: true
  address: "Bosboom Toussaintplein 273"
  zipcode: "2624DR"
  city: "Delft"
  country: "Nederland"
  tel: "0612239080"
  notes: "Dingen"

  ready: ->
    @$.animatedpages.selected = 1

  pageNext: ->
    if @$.animatedpages.selected < 3
      return (@$.animatedpages.selected += 1) and (@$.progress.value += 25)

  pagePrev: ->
    if @$.animatedpages.selected > 0
      return (@$.animatedpages.selected -= 1) and (@$.progress.value -= 25)

  checkUsername: (e) ->
    if !e.currentTarget.isEmpty
      target = e.currentTarget

  checkPassword: (e) ->
    if !e.currentTarget.isEmpty
      target = e.currentTarget
      if target.value == @$.username.value
        target.error = 'Your password can\'t be the same as your username!'
        return target.isInValid = true
      else
        return target.isInValid = false

  checkConfirmPassword: (e) ->
    if !e.currentTarget.isEmpty and @$.password.isValid
      target = e.currentTarget
      if target.value != @$.password.value
        target.error = 'Please fill in the same passwords!'
        return target.isInValid = true
      else
        return target.isInValid = false

  checkEmail: (e) ->
    re = undefined
    target = undefined
    if !e.currentTarget.isEmpty
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      target = e.currentTarget
      if !re.test(target.value)
        target.error = 'Please fill in a valid email address!'
        return target.isInValid = true
      else
        return target.isInValid = false

  setUserAJAXparams: ->
    @$.createUserAJAX.params =
      username: @username
      password: @password
      email: @email

  setProfileAJAXparams: ->
    gender = if @gender then "f" else "m"
    @$.createProfileAJAX.params =
      name: @name
      initials: @initials
      surname: @username
      gender: gender
      address: @address
      zipcode: @zipcode
      city: @city
      country: @country
      tel: @tel
      notes: @notes

  ajaxRequest: ->
    @setUserAJAXparams()
    @setProfileAJAXparams()

    @$.createUserAJAX.addEventListener 'core-response', (callback) =>
      res = JSON.parse callback.detail.response
      if res.status.code is 201
        @userhash = res.response.hash
        @userId = res.response.id

        console.log @$.createProfileAJAX.params
        # @$.createProfileAJAX.go()
      else 
        console.log "ERROR"
        @$.animatedpages.selected = 1

    @$.createProfileAJAX.addEventListener 'core-response', (callback) =>
      res = JSON.parse callback.detail.response
      switch res.status.code
        when 201 then console.log "201: SUCCESS"
        when 409 then console.log "409: ERROR"
        when 412 then console.log "412: ERROR"

    @$.createUserAJAX.go()
