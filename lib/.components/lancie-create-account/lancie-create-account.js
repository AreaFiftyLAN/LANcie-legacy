Polymer("create-account", {
  userhash: null,
  userId: null,
  username: null,
  email: null,
  password: null,
  cpassword: null,
  name: null,
  initials: null,
  surname: null,
  gender: false,
  chmember: false,
  address: null,
  zipcode: null,
  city: null,
  country: null,
  tel: null,
  notes: null,

  pageNext: function() {
    if (this.$.animatedpages.selected < 3) {
      return (this.$.animatedpages.selected += 1) && (this.$.progress.value += 25);
    }
  },

  pagePrev: function() {
    if ($.animatedpages.selected > 0) {
      return ($.animatedpages.selected -= 1) && ($.progress.value -= 25);
    }
  },

  // TODO
  checkUsername: function(e) {
    if (!e.currentTarget.isEmpty) {
      var target = e.currentTarget;

    }
  },

  checkPassword: function(e) {
    if (!e.currentTarget.isEmpty) {
      var target = e.currentTarget;
      if (target.value === this.$.username.value) {
        target.error = 'Your password can\'t be the same as your username!';
        return target.isInValid = true;
      } else {
        return target.isInValid = false;
      }
    }
  },

  checkConfirmPassword: function(e) {
    if (!e.currentTarget.isEmpty && this.$.password.isValid) {
      var target = e.currentTarget;
      if (target.value !== this.$.password.value) {
        target.error = 'Please fill in the same passwords!';
        return target.isInValid = true;
      } else {
        return target.isInValid = false;
      }
    }
  },

  checkEmail: function(e) {
    var re, target;
    if (!e.currentTarget.isEmpty) {
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      target = e.currentTarget;
      if (!re.test(target.value)) {
        target.error = 'Please fill in a valid email address!';
        return target.isInValid = true;
      } else {
        return target.isInValid = false;
      }
    }
  },

  ajaxRequest: function() {
    this.$.createUserAJAX.params = { username: this.username, password: this.password, email: this.email };
    
    this.$.createUserAJAX.addEventListener('core-response', (function(_this) {
      return function(callback) {
        var res = JSON.parse(callback.detail.response);
        if (res.status.code === 201) {
          _this.$.createProfileAJAX.params = { name: _this.name, initials: _this.initials, surname: _this.username, gender: _this.gender, address: _this.address, zipcode: _this.zipcode, city: _this.city, country: _this.country, tel: _this.tel, notes: _this.notes };
          _this.userhash = res.response.hash;
          _this.userId = res.response.id;

          // _this.$.createProfileAJAX.go();
        } else if (res.status.code === 409) {
          _this.$.animatedpages.selected = 1;
        } else if (res.status.code === 412) {

        } else {

        }
      };
    })(this));

    this.$.createProfileAJAX.addEventListener('core-response', (function(_this) {
      return function(callback) {
        var res = JSON.parse(callback.details.response);
        if(res.status.code === 201) {

        } else if (res.status.code === 409) {

        } else if (res.status.code === 412) {

        } else {
          
        }
      };
    })(this));
    
    this.$.createUserAJAX.go();
  }

});