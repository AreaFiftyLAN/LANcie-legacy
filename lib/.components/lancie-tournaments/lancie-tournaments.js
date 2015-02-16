Polymer("tournaments-element", {
  tournamentsList: null,
  
  ready: function() {
    var ajax = this.shadowRoot.querySelector("core-ajax");
    ajax.addEventListener("core-response", (function(_this) {
      return function(e) {
        _this.tournamentsList = this.response;
      };
    })(this));
  },

  onTapTournament: function(e, d, s) {
    console.log(s.querySelector('paper-action-dialog').toggle());
  }

});