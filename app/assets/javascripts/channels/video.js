$(document).on('turbolinks:load', function() {

    if($('#video-transmission').length > 0) {

        App.video = App.cable.subscriptions.create( { channel: 'VideoChannel', congregation: $('#video-transmission').data('congregation') }, {
            received: function(data) {
                Video.process(data);
            }
        });

    }
    else {
        if(App.video) {
            App.video.unsubscribe();
            App.video = null
        }
    }

});

var Video = {

    initialize: function() {

        var _this = this;

        $(document).on("click", ".alert .close", function(e) {
            e.preventDefault();
            var link = $(this);
            link.closest('.alert').hide();
        });

        $(document).on('ajax:beforeSend', '.generate-video-transmission', function(event, xhr, settings) {
            $(this).hide();
            $('.preparing-video-transmission').show();
        });

        $(document).on('click', '.remove-video-preview', function(event) {
            event.preventDefault();
            var link = $(this);
            link.parents('#video-preview-wrapper').remove();
        });

        $(document).on('click', '.manage-users', function(event) {
            event.preventDefault();
            var link = $(this);
            $.get(link.attr('href'), function(data){
                var modal = $('#dynamic-modal');
                modal.html(data);
                modal.modal('show');
            });
        });

        $(document).on('submit', '#edit-broadcast-form', function(e) {
            e.preventDefault();
            form = $(this);
            $.ajax(form.attr('action'),{
                method: 'PATCH',
                data: form.serialize(),
                success: function(data, success, xhr) {

                    if(data['users']) {
                        _this.renderUsers(data['users']);
                    }

                },

                complete: function() {
                    modal = $('#dynamic-modal');
                    modal.modal('hide');
                    modal.html('')
                }
            })
        });


        $(document).on('turbolinks:click', function(){

            if($('#video-transmission').length > 0) {

                $('#video-preview-wrapper').hide();
            }

        });

        $(document).on('turbolinks:load', function() {

            if($('#video-transmission').length > 0) {

                _this.videoUserTemplate = $.template("video", $('#video-user-template').html() );

                var initial_data = $('#video-transmission').data('initial');

                if(initial_data) {

                    if(initial_data['status'] == 'initializing') {
                        $('.generate-video-transmission').hide();
                        $('.preparing-video-transmission').show();
                    } else {
                        $('#broadcast-users').show();

                        if(YT.Player){
                            _this.createPreview(initial_data['broadcast_id']);
                        }
                    }

                    if(initial_data['users']){
                        _this.renderUsers(initial_data['users']);
                    }

                }
                else {
                    if($('#youtube-refresh:visible').length == 0){
                        $('.generate-video-transmission').show();
                    }
                }

            }
        })

        window.onYouTubeIframeAPIReady = function() {
            var initial_data = $('#video-transmission').data('initial');
            if(initial_data) {
                if(initial_data['status'] == 'live') {
                    _this.live(initial_data);
                }
            }
        }
        
    },

    process: function(data) {
        this[data.action](data);
    },

    live: function(data) {
        $('.preparing-video-transmission').hide();
        $('.generate-video-transmission').hide();

        $('#video-transmission').find('.message').hide();

        this.createPreview(data['broadcast_id']);

        $('#broadcast-users').show();

        if(data['users']) {
            this.renderUsers(data['users']);
        }
    },

    message: function(data) {
        error_container = $('#video-transmission').find('.message');
        error_container.html(data['message_content']);
        error_container.show();
    },

    count: function(data) {
        $("#video-transmission-user-"+ data['user_id']).replaceWith($.tmpl(this.videoUserTemplate, data))
    },

    connection_error: function(data) {
        $('#youtube-refresh').show();
    },

    renderUsers: function(users) {
        var _this = this;

        $('#broadcast-users').show();
        $('#video-users').html('');
        $.each(users, function (index, user) {
            $('#video-users').append($.tmpl(_this.videoUserTemplate, user));
        });
    },

    player: null,

    createPreview: function(broadcast_id) {

        $('#video-preview-wrapper').show();

        this.player = new YT.Player('video-preview', {
            videoId: broadcast_id, // YouTube Video ID
            width: 300,               // Player width (in px)
            height: 150,              // Player height (in px)
            playerVars: {
                autoplay: 1,        // Auto-play the video on load
                controls: 1,        // Show pause/play buttons in player
                showinfo: 0,        // Hide the video title
                modestbranding: 1,  // Hide the Youtube Logo
                loop: 1,            // Run the video in a loop
                fs: 0,              // Hide the full screen button
                cc_load_policy: 0,  // Hide closed captions
                iv_load_policy: 3,  // Hide the Video Annotations
                autohide: 0         // Hide video controls when playing
            },
            events: {
                onReady: function(e) {
                    e.target.mute();
                }
            }
        });

        direct_url = "https://www.youtube.com/watch?v=" + broadcast_id;
        direct_link_text = '<span>';
        direct_link_text += 'Bezpośredni link (do użycia w awaryjnych sytuacjach): ';
        direct_link_text += '<br/>';
        direct_link_text += '<a href="' + direct_url + '" target="_blank">' + direct_url + '</a>';
        direct_link_text += '</span>';

        $('#direct-url').html(direct_link_text)
    }

}

Video.initialize();