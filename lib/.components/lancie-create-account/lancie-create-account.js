Polymer("create-account", {

  ready: function() {

  },

  pageNext: function() {
    var animated = this.getElement("core-animated-pages");
    
    /* Check inputs on slide 1 */
    if (animated.selected == 0) {
      if(!(this.checkEmptyTarget( this.getElement("#uname") ) && this.checkEmptyTarget( this.getElement("#upass") ) && this.checkEmptyTarget( this.getElement("#email") ) && this.checkUsername() && this.checkPassword() && this.checkConfirmPassword() && this.checkEmail() && this.checkTerms())) return;
      animated.selected += 1;
      this.getElement("paper-progress").value += 25;
    } else if (animated.selected == 1) {
      if(!( this.checkEmptyTarget( this.getElement("#name") ) && this.checkEmptyTarget( this.getElement("#voorletters") ) && this.checkEmptyTarget( this.getElement("#achternaam") ) && this.checkEmptyTarget( this.getElement("#adres") ) && this.checkEmptyTarget( this.getElement("#postcode") ) && this.checkEmptyTarget( this.getElement("#stad") ) && this.checkEmptyTarget( this.getElement("#telnr") ) && this.checkValidPhone()
        )) return;
      animated.selected += 1;
      this.getElement("paper-progress").value += 25;

      /* Call to add the data to the database */
      
    }
    
  },

  pagePrev: function() {
    var page = this.getElement("core-animated-pages");
    page.selected -= (page.selected > 0) ? 1 : 0;
    this.getElement("paper-progress").value -= (page.selected > 0) ? 25 : 0;
  },


  /**
   * Validation of the lancie-inputs
   */
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

  // TODO
  checkUsername: function() {
    var username = this.shadowRoot.querySelector("#uname");
    var password = this.shadowRoot.querySelector("#upass");
    var decUsername = this.getDecorator(username);

    if(username.isEmpty) return;

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

    /* Break if element is empty */
    if(password.isEmpty) return;

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
    var password = this.getElement("#upass");
    var confirmPassword = this.getElement("#ucpass");

    /* Break if element is empty */
    if(password.isEmpty || confirmPassword.isEmpty) return;

    var decPassword = this.getDecorator(password);
    var decCPassword = this.getDecorator(confirmPassword);

    /* Check if password and confirmPassword are the same */
    if (password.value !== confirmPassword.value) {
      password.error = confirmPassword.error = 'Please fill in the same passwords!';
      decPassword.isInvalid = decCPassword.isInvalid = true;
      return false;
    }
    decPassword.isInvalid = decCPassword.isInvalid = false;
    return true;
  },

  checkEmail: function() {
    var email = this.getElement("#email");
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

  checkTerms: function() {
    var terms = this.shadowRoot.querySelector("#terms");
    if (!terms.checked) {
      return false;
    }
    return true;
  },

  checkValidPhone: function() {
    var phone = this.getElement("#telnr");
    var decPhone = this.getDecorator(phone);

    /* Break if phone number is empty */
    if (phone.isEmpty) return;

    /* Check if phone number is valid */
    if (isNaN(phone.value)) {
      phone.error = 'A phone number can only contain digits';
      decPhone.isInvalid = true;
      return false;
    }
    decPhone.isInvalid = false;
    return true;
  },

  getDecorator: function(element) {
    return element.shadowRoot.querySelector("paper-input-decorator");
  },

  getElement: function(element) {
    return this.shadowRoot.querySelector(element);
  } 

});