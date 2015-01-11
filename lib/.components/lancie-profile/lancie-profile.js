Polymer("profile-element", {
  profile: null,
  
  ready: function() {
  	var form = this.shadowRoot.querySelector("#profileForm");
  	this.shadowRoot.querySelector("#submitButton").addEventListener('click', function() {
    	form.submit(); 
   });
  	form.addEventListener('submitting',
    function(event) {
        var formData = event.detail.formData;
        formData.aanhef = form.querySelector('#profileAanhef').selected;
        console.log(formData);
    }
);
    var ajax = this.shadowRoot.querySelector("core-ajax");
    ajax.addEventListener("core-response", (function(_this) {
      return function(e) {
        _this.profile = this.response;
      };
    })(this));
  },

});