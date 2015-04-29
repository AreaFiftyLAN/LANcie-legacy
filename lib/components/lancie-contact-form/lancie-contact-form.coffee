Polymer 'lancie-contact',

  ready: ->
    @$.mailAJAX.addEventListener 'core-response', (callback) =>
      res = callback.detail.response
      @$.sendingMail.setAttribute "hidden", ""
      if res.status is 201
        @$.receivedMail.removeAttribute "hidden"
        setTimeout =>
          @$.contactUs.toggle()
        , 2000
      else
        @$.tryAgain.removeAttribute "hidden"

      @$.receivedMail.setAttribute "hidden", ""
      @$.tryAgain.setAttribute "hidden", ""

  show: ->
    @$.contactUs.toggle()

  submit: ->
    @$.sendingMail.removeAttribute "hidden"
    setTimeout =>
      @$.mailAJAX.go()
    , 5000

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