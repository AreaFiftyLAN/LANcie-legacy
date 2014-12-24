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

});