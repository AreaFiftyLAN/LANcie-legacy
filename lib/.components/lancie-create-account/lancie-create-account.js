Polymer("create-account", {

  ready: function() {
    this.shadowRoot.querySelector("core-animated-pages").selected += 1;
  },

  clicked: function() {
    var ajax = this.shadowRoot.querySelector("core-ajax");
    ajax.go();

    ajax.addEventListener("core-error", (function(_this) {
      return function(e) {
        console.log(e);
      };
    })(this));
  },

  pageNext: function() {
    var animated = this.shadowRoot.querySelector("core-animated-pages");
    // animated.selected += 1;
    if (animated.selected == 0) {
      if(!(this.checkUsername() && this.checkPassword() && this.checkConfirmPassword() && this.checkEmail() && this.checkTerms())) return;
      animated.selected += 1;
    }


    this.shadowRoot.querySelector("paper-progress").value += 25;
  },

  pagePrev: function() {
    this.shadowRoot.querySelector("core-animated-pages").selected -= 1;
    this.shadowRoot.querySelector("paper-progress").value -= 25;
  },


  /**
   * Validation of the lancie-inputs
   */

  // TODO
  checkUsername: function() {
    var username = this.shadowRoot.querySelector("#uname");
    var password = this.shadowRoot.querySelector("#upass");
    var decUsername = this.getDecorator(username);

    /* Username isn't empty */
    if (username.value === undefined || username.value === '') {
      username.error = 'Please fill in a username!';
      decUsername.isInvalid = true;
      return false;
    }

    /* Check if username is already taken */


    if (password.value != '') this.checkPassword();
    decUsername.isInvalid = false;
    return true;
  },

  // TODO
  checkPassword: function() {
    var password = this.shadowRoot.querySelector("#upass");
    var username = this.shadowRoot.querySelector("#uname");
    var decPassword = this.getDecorator(password);

    /* Check if confirm password isn't empty */
    if (password.value === undefined || password.value === '') {
      password.error = 'Please fill in a password!';
      decPassword.isInvalid = true;
      return false;
    }

    /* Check if username isn't the same as username */
    if (password.value === username.value) {
      password.error = "Your password can't be the same as your username!";
      decPassword.isInvalid = true;
      return false;
    }

    if (decPassword.isInvalid) this.checkConfirmPassword();
    decPassword.isInvalid = false;
    return true;
  },

  checkConfirmPassword: function() {
    var password = this.shadowRoot.querySelector("#upass");
    var confirmPassword = this.shadowRoot.querySelector("#ucpass");

    var decPassword = this.getDecorator(password);
    var decCPassword = this.getDecorator(confirmPassword);

    if (password.value != '' || decPassword.isInvalid !== true) {

      /* Check if confirm password isn't empty */
      if (confirmPassword.value === undefined || confirmPassword.value === '') {
        confirmPassword.error = 'Please confirm your password!';
        decCPassword.isInvalid = true;
        return false;
      }

      /* Check if password and confirmPassword are the same */
      if (password.value !== confirmPassword.value) {
        password.error = confirmPassword.error = 'Please fill in the same passwords!';
        decPassword.isInvalid = decCPassword.isInvalid = true;
        return false;
      }
      decPassword.isInvalid = decCPassword.isInvalid = false;
      return true;
    }
    return false;
  },

  checkEmail: function() {
    var email = this.shadowRoot.querySelector("#email");
    var decEmail = this.getDecorator(email);

    /* Check if email isn't empty */
    if (email.value === undefined || email.value === '') {
      email.error = 'Please fill in a email address!';
      decEmail.isInvalid = true;
      return false;
    }

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

  checkTerms: function() {
    var terms = this.shadowRoot.querySelector("#terms");
    if (!terms.checked) {
      return false;
    }
    return true;
  },

  getDecorator: function(element) {
    return element.shadowRoot.querySelector("paper-input-decorator");
  }

});