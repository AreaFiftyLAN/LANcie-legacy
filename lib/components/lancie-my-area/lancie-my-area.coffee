Polymer 'lancie-my-area',

  userhash: "AREA51LAN55522884D51E0"
  userid: 37897728

  ###
    Start on DOM loaded
  ###
  ready: ->
    @$.myAreaSidemenu.addEventListener 'core-activate', =>
      @$.pagesHolder.selected = @$.myAreaSidemenu.selectedIndex

  ###

  ###
  signOut: ->
    @$.sessionDestroyAJAX.go()
    