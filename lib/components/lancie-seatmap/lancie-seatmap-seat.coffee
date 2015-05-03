Polymer 'lancie-seatmap-seat',
  modeoptions: [
    {
      name: "open"
      colors: 
        default:
          background: "#eeecec"
          border: "rgba(90, 90, 90, 0.6)"
        checked:
          background: "#3a5278"
          border: "rgba(90, 90, 90, 0.33)"
      tooltip: false
      disabled: false
    },
    {
      name: "occupied"
      colors: 
        default:
          background: "red"
          border: "rgba(90, 90, 90, 0.33)"
      tooltip: true
      disabled: false
    },
    {
      name: "self"
      colors: 
        default:
          background: "red"
          border: "rgba(90, 90, 90, 0.1)"
      tooltip: true
      disabled: false
    },
    {
      name: "disabled"
      colors: 
        default:
          background: "#eeecec"
          border: "rgba(90, 90, 90, 0.1)"
      tooltip: false
      disabled: true
    }
  ]

  data:
    seat:
      row: "A",
      column: 11
    user:
      name: "Sven Popping"

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
    if parseInt( @data.seat.userid ) isnt 0 
      @mode = "occupied"
      @$.getUsernameAJAX.go()
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

  checkedChanged: ->
    @setAttribute 'aria-checked', if @checked then 'true' else 'false'
    @fire 'core-change'

  ###
    
  ###
  getDataFromMode: (mode) -> 
    for modeoption in @modeoptions
      return modeoption if modeoption.name is mode
    return @defaultmode
