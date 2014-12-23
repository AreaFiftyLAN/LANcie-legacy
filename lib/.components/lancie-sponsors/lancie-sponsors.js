Polymer("sponsors-element", {
  height: "300",
  sponsorsList: null,

  ready: function() {
    var ajax = this.shadowRoot.querySelector("core-ajax");
    ajax.addEventListener("core-response", (function(_this) {
      return function(e) {
        _this.sponsorsList = this.response;
      };
    })(this));
  }

});