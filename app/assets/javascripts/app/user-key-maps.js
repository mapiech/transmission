var UserKeyMap = {

    initialize: function(){

        var _this = this;

        if($('#phone-form')) {

            $(document).on('click', '.clear-map-key-name', function(e){
                e.preventDefault();
                $(this).parents('.user-key-maps-entry-form').find('.user-key-maps-full-name-edit-input').val('');
            });

            $(document).on('blur', '#user-full-name-edit-input', function(e) {
                e.preventDefault();
                _this.copyUserToFirstMapKey(false);
            });

            $(document).on('click', '.copy-user-full-name', function(e) {
                e.preventDefault();
                _this.copyUserToFirstMapKey(true);
            });

        }

    },

    copyUserToFirstMapKey: function(force) {
        user_name_input = $('#user-full-name-edit-input');
        first_key_name_input = $('.user-key-maps-full-name-edit-input:first');

        if(force) {
            first_key_name_input.val(user_name_input.val());
        }
        else {
            if(first_key_name_input.val() == '') {
                first_key_name_input.val(user_name_input.val());
            }
        }
    }

}

UserKeyMap.initialize();