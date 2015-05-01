Polymer 'lancie-seatmap-seat',
  modeoptions: [
    {
      name: "open"
      icon: {
        type: "square-o"
        color: "green"
      }
      tooltip: false
    },
    {
      name: "selected"
      icon: {
        type: "square"
        color: "green"
      }
      tooltip: false
    },
    {
      name: "occupied"
      icon: {
        type: "square"
        color: "red"
      }
      tooltip: true
    }
  ]

  defaultmode: {
    name: "disabled"
    icon: {
      type: "minus-square-o"
      color: "orange"
    }
    tooltip: false
  }

  data: {
    seat: {
      row: "A",
      column: 11
    },
    user: {
      name: "Sven Popping"
    }
  }

  ready: ->

  ###
    
  ###
  getDataFromMode: (mode) -> 
    for modeoption in @modeoptions
      return modeoption if modeoption.name is mode
    return @defaultmode
