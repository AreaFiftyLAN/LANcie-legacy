Polymer("create-account", {

  ready: function() {
    console.log("ready");
  },

  clicked: function() {
    var ajax = this.shadowRoot.querySelector("core-ajax");
    ajax.go();

    ajax.addEventListener("core-error", (function(_this) {
      return function(e) {
        console.log(e);
      };
    })(this));
  }

});