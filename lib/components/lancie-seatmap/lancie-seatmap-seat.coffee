Polymer 'lancie-seatmap-seat',
  modeoptions: [
    {
      name: "open"
      colors: 
        default:
          background: "#eeecec"
          borderColor: "rgba(90, 90, 90, 0.6)"
        checked:
          background: "#3a5278"
          borderColor: "rgba(90, 90, 90, 0.33)"
      tooltip: false
      disabled: false
    },
    {
      name: "occupied"
      colors: 
        default:
          background: "#ff0000"
          borderColor: "rgba(90, 90, 90, 0.33)"
        checked:
          background: "red"
          borderColor: "rgba(90, 90, 90, 0.33)"
      tooltip: true
      disabled: false
    },
    {
      name: "self"
      colors: 
        default:
          background: "#ff0000"
          borderColor: "rgba(90, 90, 90, 0.1)"
      tooltip: true
      disabled: false
    },
    {
      name: "disabled"
      colors: 
        default:
          background: "#eeecec"
          borderColor: "rgba(90, 90, 90, 0.1)"
      tooltip: false
      disabled: true
    }
  ]

  publish:
    checked:
      value: false
      reflect: true

    label: ''

    toggles: true

    disabled:
      value: false
      reflect: true

  eventDelegates: tap: 'tap'

  ready: ->
    if @data.seat.userid isnt null
      @mode = "occupied"
    else 
      @mode = "open"

    modeoption = @getDataFromMode @mode
    if modeoption.disabled is true
      @setAttribute 'disabled', true

  tap: ->
    if @disabled then return
    old = @checked
    @toggle()

    if @mode is "open" then @openTooltip()

    if @checked != old
      @fire 'lancie-seatmap-seat-tap'

  openTooltip: ->
    @$.coreTooltip.setAttribute 'focussed', true

  toggle: ->
    @checked = !@toggles or !@checked

  reserveSeatEvent: ->
    @fire 'lancie-seatmap-reserve', @

  checkedChanged: ->
    @setAttribute 'aria-checked', if @checked then 'true' else 'false'
    @fire 'core-change'

  ###
    
  ###
  getDataFromMode: (mode) -> 
    for modeoption in @modeoptions
      return modeoption if modeoption.name is mode
    return @defaultmode
