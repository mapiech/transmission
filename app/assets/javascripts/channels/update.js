$(document).on('turbolinks:load', function() {

    if($('#phone-transmission').length > 0) {

        App.update = App.cable.subscriptions.create( { channel: 'UpdateChannel', transmission: $('body').data('transmission') }, {

           received: function(data) {
             Users.process(data);
           }

        });

    }
    else {
        if(App.update) {
            App.update.unsubscribe();
            App.update = null
        }
    }

});

var Users = {

    initialize: function() {

        var _this = this;


        $(document).on('turbolinks:load', function() {

            _this.channelTemplate = $.template("channel", $('#channel-template').html() );
            _this.muteAreaTemplate = $.template("mute-area-template", $('#mute-area-template').html() );


            // load initial data

                var initial_data = $('#phone-transmission').data('initial');
                // load users
                if($('#phone-transmission').length > 0) {
                    channels = initial_data['users'];
                    $.each(channels, function (index, data) {
                        _this.create(data);
                    });
                }

                // set unmuted

                _this.unmuted(initial_data['unmuted']);

        });

        $(document).on('click', '.mute-action', function(e){
            e.preventDefault();
            link = $(this);
            if(!link.hasClass('disabled')) {
                $.post(link.attr('href'));
                if (link.hasClass('mute')) {
                    link.addClass('disabled');
                } else {
                    link.hide();
                }
            }
        })


    },

    process: function(data) {
        this[data.action](data);
    },

    generateHTML: function(data) {

        return $.tmpl(this.channelTemplate, data);
    },

    create: function(data) {

        if($('#phone-transmission-user-'+data.user_id).length > 0) {

            this.update(data);

        }
        else
            {
                if (data.admin) {
                    $('#phone-transmission').prepend(this.generateHTML(data));
                } else {
                    $('#phone-transmission').append(this.generateHTML(data));
                }
            }
    },

    update: function(data) {
        $('#phone-transmission-user-'+data.user_id).replaceWith(this.generateHTML(data));
    },

    update_count: function(data) {
        element = $('#phone-transmission-users-count-'+data.user_id);
        element.text(data['users_count_text']);
        element.data('users-count', data.users_count);
    },

    destroy: function(data) {
        $('#phone-transmission-user-'+data.user_id).remove();
    },

    unmuted: function(data) {

        modal = $('#comment-modal');

        if(data.admin) {
            $('.unmute').show();
            $('.admin-play').show();
            modal.modal('hide');
        }
        else {
            modal.find('.modal-body').html($.tmpl(this.muteAreaTemplate, data));
            $('.admin-play').hide();
            modal.modal('show');
        }
    },

    comment: function(data) {
        Comments.process(data)
    }

}

Users.initialize();

var Comments = {

    initialize: function() {

        var _this = this;

        $(document).on('turbolinks:load', function() {
            _this.commentTemplate = $.template("comment", $('#comment-template').html() );
        });

        _this.timers = {};

    },

    process: function(data) {
        this[data.comment_action](data);
    },

    create: function(data) {

        existing_comment = $("#phone-transmission-user-"+data.user_id+"-comment-digit-"+data.digit);

        if(existing_comment.length > 0){
            existing_comment.replaceWith($.tmpl(this.commentTemplate, data));
        } else {
            $('#phone-transmission-user-'+data.user_id).find('.comments').append($.tmpl(this.commentTemplate, data));
        }

        try{clearTimeout(this.timers['user-'+ data.user_id + '-' + data.digit]);}catch(e){}
        this.timers['user-'+ data.user_id + '-' + data.digit] = setTimeout(function(){
            $("#phone-transmission-user-"+data.user_id+"-comment-digit-"+data.digit).remove();
        }, 15000);
    },

    destroy: function(data) {

        var _this = this;

        $.each($('#phone-transmission-user-'+data.user_id).find('.comment-entry'), function (index, comment_entry) {


            var comment_entry = $(comment_entry);
            var digit = comment_entry.data('digit');

            try{clearTimeout(_this.timers['user-'+ data.user_id + '-' + digit]);}catch(e){}

            _this.timers['user-'+ data.user_id + '-' + digit] = setTimeout(function(){
                $("#phone-transmission-user-"+data.user_id+"-comment-digit-"+digit).remove();
            }, 5000);

            comment_entry.addClass('disabled');
        });
    }

}
Comments.initialize();