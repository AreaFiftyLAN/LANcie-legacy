Polymer("cprofile-element", {
  memberList: null,
  
  ready: function() {
    var ajax = this.shadowRoot.querySelector("core-ajax");
    ajax.addEventListener("core-response", (function(_this) {
      return function(e) {
        _this.memberList = this.response;
      };
    })(this));
  },

});