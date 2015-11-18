window.Ibles = window.Ibles || {};

(function($){
       
    /** 
     * handles interactions between and within login, signup and gopro modals
     */
     
    var IbleAuthFlow = function(options) {
        this.init(options);
    };
    
    IbleAuthFlow.prototype = {
        constructor: IbleAuthFlow,
        
        init: function(options) {
            if (options && !options.loggedIn) {
                this.options = options;
                this.loginModal = $('.auth-login-modal:not(.inline)');
                this.inlineLogin = $('.auth-login-modal.inline');             
                this.signupModal = $('.auth-register-modal:not(.inline)');
                this.inlineSignup = $('.auth-register-modal.inline');
                this.forgotModal = $('.auth-forgot-modal:not(.inline)');
                this.inlineForgot = $('.auth-forgot-modal.inline');
                this.resetModal = $('.auth-reset-modal:not(.inline)');
                this.inlineReset = $('.auth-reset-modal.inline');
                this.proModal = $('.auth-gopro-modal');
                this.bindEvents();
            }
        },
        
        bindEvents: function() {
            var self = this;            
            $(document).on("click", ".login-link, .login-required", $.proxy(this.showLoginModal, this));
            $(document).on("click", ".pro-required", $.proxy(this.showProModal, this));         
            //$(document).on("click", ".signup-link", $.proxy(this.showSignupModal, this));
            $(document).on("click", ".forgot-link", $.proxy(this.showForgotModal, this));
            $(document).on("click", ".logout-link", $.proxy(this.logout, this));

            this.validate('.auth-form.login-form', $.proxy(this.submitLogin, this));
//            this.validate('.auth-form.register-form', $.proxy(this.submitSignup, this)); //uncomment once api register is fixed
            this.validate('.auth-form.forgot-form', $.proxy(this.submitForgot, this));
            this.validate('.auth-form.reset-form', $.proxy(this.submitReset, this));
            
            $.each([this.inlineLogin, this.inlineSignup, this.inlineForgot, this.inlineReset], function(i, $modal) {
                self.afterModalShown($modal);
            });
            
            $.each([this.loginModal, this.signupModal, this.forgotModal, this.resetModal], function(i, $modal) {
                $modal.on('shown', $.proxy(self.afterModalShown, self, $modal));
            });
        },
        
        afterModalShown: function($modal) {
            $modal.find('input').filter(':visible:first').focus();                
            $modal.find('.carousel').carousel({interval: 3000});            
            if ($modal.hasClass('auth-register-modal') && $modal.is(":visible")) {
                this.afterSignupShown($modal);
            }
        },
        
        afterSignupShown: function($modal) {
            if (!$modal.data('signup-initialized')) {
                $modal.find(".username-field").keyup($.proxy(function(){this.usernameCheck($modal)}, this));
                this.setCsrfToken($modal);                
                $modal.data('signup-initialized', true);
            }           
        },

        showLoginModal: function(e) {
            this.hideCurrentModal();
            if (typeof e !== 'undefined')
                e.preventDefault();
            this.loginModal.modal('show');          
        },
        
        showSignupModal: function(e) {
            this.hideCurrentModal();
            if (typeof e !== 'undefined')
                e.preventDefault();
            this.signupModal.modal('show');        
        },

        showForgotModal: function(e) {
            this.hideCurrentModal();
            if (typeof e !== 'undefined')
                e.preventDefault();
            this.forgotModal.modal('show');            
        },
        
        showProModal: function(e) {
            this.hideCurrentModal();
            if (typeof e !== 'undefined')
                e.preventDefault();
            this.proModal.modal('show');            
        },
        
        hideCurrentModal: function() {
            $('.auth-modal:not(.inline)').filter(':visible').modal('hide');
        },
        
        usernameCheck: function($modal) {
            var $field = $modal.find('.username-field'),
                username = $field.val().trim();
                
            if (username.length) {
                delay(function() {
                    $.ajax({
                        type: "GET",
                        url: "/ajax/AjaxUserNameChecker/",
                        data: {'userName' : username},
                        dataType: "json",
                        success: function(data){
                            if (data.error) {
                                var $alert = $modal.find('.alert-error')
                                if (!$alert.length) {
                                    $alert = $('<p class="help-block username-status alert alert-error">'),
                                    $field.after($alert);
                                }
                                $alert.text($field.data("validation-username-message"));
                            } else {
                                if ($field.next().hasClass('username-status'))
                                    $field.next().remove();
                            }
                        }                            
                    });
                }, 2000);
            }
        },
        
        setCsrfToken: function($modal) {
            var self = this;
            $.ajax({
                type: "GET",
                url: "/account/register/",
                data: {'requestToken' : 'true'},
                dataType: "text",
                success: function(data){
                    $modal.find("form").append($('<input name="timestamp" type="hidden"/>').val(data.trim()));
                }                            
            });            
        },

        getUrlParam: function(window, name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(window.location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        },
        
        validate: function(formSelector, submitHandler) {
            var showErrors = function(errorMap, errorList){
                    _.each(errorList, function(error){
                        $(error.element).tooltip({title:error.message, trigger:"manual"});
                        $(error.element).tooltip('show');
                        //tooltip position is set using js in bootstrap so we have to override it here
                        $(error.element).next('.tooltip').css({left:'auto',right:'20px'});
                        window.setTimeout(function() {
                            $(error.element).tooltip('hide').tooltip('destroy');
                        }, 3000)
                    })
                };
            $(formSelector).each(function() {
               $(this).validate({
                   submitHandler: submitHandler,
                   showErrors:showErrors
               });
            });
        },        
        
        submitLogin: function(form) {
            var $form = $(form),
                self = this,
                label = $form.find('.login-error-label'),
                button = $form.find('button.auth-action');
            label.hide();
            button.button('loading');

            $.ajax({
                url: "/json-api/login",
                dataType: 'json',
                type: 'POST',
                data: {
                    p: $form.find('input[name="p"]').val(),
                    u: $form.find('input[name="u"]').val(),
                    RememberME: 'true'                    
                },
                success: function(data){
                    self.postAuthRedirect();
                },
                error: function(jqXHR){
                    if (_.has(jqXHR.responseJSON, 'error')){
                        self.loginFormError($form, jqXHR.responseJSON.error)
                    }
                },
                complete: function() {
                    button.button('reset');
                }

            });            
        },

        loginFormError:function(form, error){
            var label = form.find('.login-error-label'),
                carousel = form.parent().find('#gopro-carousel');
            label.text(error);
            carousel.slideUp({duration:'fast', queue:false})
            label.slideDown({queue:false});
        },

        submitImplicitLogin: function(username, password, callback){
            $.ajax({
                url: "/json-api/login",
                dataType: 'json',
                type: 'POST',
                data: {
                    u: username,
                    p: password,
                    RememberME: 'true'                    
                },
                success: function(data){
                    if (callback) callback();
                },
                error: function(jqXHR){
                },
                complete: function(jqXHR){      
                }
            });
        },
                
        submitSignup: function(form) {
            var $form = $(form),
                self = this,
                password = $form.find('input[name="password"]').val(),
                screenName = $form.find('input[name="screenName"]').val(),
                button = $form.find('button.auth-action');
                
            button.button('loading');

            $.ajax({
                url: "/account/register/",
//                dataType: 'json',
                type: 'POST',
                data: {
                    email: $form.find('input[name="email"]').val(),
                    screenName: screenName,
                    password: password,
                    passRT: password,
                    timestamp: $form.find('input[name="timestamp"]').val(),                    
                    sendNewsletter: 'true',
                    RememberME: 'true'                   
                },
                success: function(data){
                    self.submitImplicitLogin(screenName, password, function(){
                        self.postAuthRedirect();
                    });                    
                },
                error: function(jqXHR){
                    try {
                        $.proxy(self.parseError, self)(jqXHR, $form);
                    }
                    catch(e) {
                        jqXHR.responseJSON = {"error": "Unknown error."};
                        $.proxy(self.parseError, self)(jqXHR, $form);
                    }
                },
                complete: function() {
                    button.button('reset');
                }
            });                                  
        },
        
        submitForgot: function(form) {
            var $form = $(form),
                self = this,
                email = $form.find('input[name="email"]').val(),
                button = $form.find('button.auth-action');
            button.button('loading');
                
            $.ajax({
                url: "/json-api/forgotPassword",
                dataType: 'json',
                type: 'POST',
                data: {
                    email: email              
                },
                success: function(data){
                    self.hideCurrentModal();
                    $.each([self.resetModal, self.inlineReset], function(){
                        var resetPanel = $(this);
                        // the screenName field acts as email field or username field
                        resetPanel.find('input[name="screenName"]').val(email);
                        self.resetModal.modal('show');
                    });
                },
                error: function(jqXHR){
                    $.proxy(self.parseError, self)(jqXHR, $form);
                },
                complete: function() {
                    button.button('reset');
                }

            });            
        },   
        
        submitReset: function(form) {
            var $form = $(form),
                self = this,
                newPassword = $form.find('input[name="newPassword"]').val(),
                button = $form.find('button.auth-action');
            button.button('loading');
                
            $.ajax({
                url: "/json-api/resetPassword",
                dataType: 'json',
                type: 'POST',
                data: {
                    email: $form.find('input[name="screenName"]').val(),
                    resetCode: $form.find('input[name="tempCode"]').val(),
                    password: newPassword,
                    passRT: newPassword          
                },
                success: function(data){
                     self.submitImplicitLogin(data["screenName"], newPassword, function(){
                         self.postAuthRedirect();
                     });
                },
                error: function(jqXHR){
                    $.proxy(self.parseError, self)(jqXHR, $form);
                },
                complete: function() {
                    button.button('reset');
                }
            });            
        },

        parseError:function(jqXHR, $form){
            if (_.has(jqXHR.responseJSON, 'error')){
                this.resetOrForgotError($form, jqXHR.responseJSON.error)
            } else if (_.has(jqXHR.responseJSON, 'validationErrors')){
                this.resetOrForgotError($form, this.makeErrorMessage(jqXHR.responseJSON.validationErrors));
            }
        },

        makeErrorMessage:function(errorJSON){
            var compiledErrors = _.reduce(_.keys(errorJSON), function(memo, key){
                 return memo + " " + errorJSON[key];
            }, "");
            return compiledErrors;
        },

        resetOrForgotError: function(form, error){
            var label = form.find('.modal-error-label');
            label.text(error);
            label.slideDown();
        },
        
        logout: function(e){
            if (typeof e !== 'undefined')
                e.preventDefault();            
            $.ajax({
                url: '/json-api/logout',
                dataType: 'json',
                type: 'POST'
            }).always(function(){window.location.reload(true);})
        },
        
        postAuthRedirect: function() {
            var currentUrl = window.location.href,
                authPaths = this.options.authPaths,
                onAuthPath = false;
                
            for (var i=0; i < authPaths.length; i++) {
                onAuthPath = onAuthPath || (currentUrl.indexOf(authPaths[i]) >= 0);
            }
            
            if (!onAuthPath) {
                window.location.reload(true);
            } else {
                var nextPageValue = this.getUrlParam(window, this.options.nextPageParameter);
                if (nextPageValue) {
                    window.location = nextPageValue;
                } else {
                    window.location = "/";
                }
            }
        }          
    };

    var delay = (function(){
        var timer = 0;
        return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
        };
    })();
    
    window.Ibles.AuthFlow = IbleAuthFlow;
})(jQuery)
