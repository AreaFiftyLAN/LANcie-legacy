Polymer("pre-registration-element", {
  name: null,
  email:null,

  ready: function() {

  },



  submit: function() {
    this.name = this.$.name.value;
    this.email = this.$.email.value;

    if(this.checkEmail() && this.checkEmptyTarget(this.$.name) && this.checkEmptyTarget(this.$.email)){
      this.$.preregistrationAJAX.go();
    }

    this.$.preregistrationAJAX.addEventListener('core-response', (function(_this) {
      return function(callback) {
        console.log(callback.detail.response);
        _this.$.submitToast.show();
        _this.name = _this.email = null;
      };
    })(this));


  },

  checkEmptyTarget: function(target) {
    var element = target.currentTarget || target;
    var decElement = this.getDecorator(element);

    if (element.value === undefined || element.value === '') {
      element.error = 'Please fill in this input!'
      decElement.isInvalid = element.isEmpty = true;
      return false;
    }
    decElement.isInvalid = element.isEmpty = false;
    return true;
  },

  checkEmail: function() {
    var email = this.$.email;
    var decEmail = this.getDecorator(email);

    /* Break if email is empty */
    if (email.isEmpty) return;

    /* Check if email is valid */
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (!re.test(email.value)) {
      email.error = 'Please fill in a valid email address!'
      decEmail.isInvalid = true;
      return false;
    }
    decEmail.isInvalid = false;
    return true;
  },

  getDecorator: function(element) {
    return element.shadowRoot.querySelector("paper-input-decorator");
  },

});