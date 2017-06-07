$(document).on('ajax:beforeSend', '.set-count', function(event, xhr, settings) {
    link = $(this);
    link.parents('#user-counts').find('a').addClass('disabled');
    link.parents('#user-counts').find('a').removeClass('btn-primary');
});

$(document).on('ajax:success', '.set-count', function(event, xhr, settings) {
    link = $(this);
    link.addClass('btn-primary');
    $('#user-counts').data('count', link.data('count'));    
    Video.createVideo();

});

$(document).on('ajax:complete', '.set-count', function(event, xhr, settings) {
    link = $(this);
    link.parents('#user-counts').find('a').removeClass('disabled');
});

var Users = {

    initialize: function() {

        var _this = this;

        $(document).on('turbolinks:load', function() {

            if($('#user-counts').length > 0) {
                $('.set-count[data-count='+_this.count()+']').addClass('btn-primary');
            }

        })
    },

    count: function() {
        return $('#user-counts').data('count');
    }

}

Users.initialize();


var Video = {

    initialize: function() {

        var _this = this;

        $(document).ready(function(){
            $(window).resize(function(){
                _this.setHeight();
            })
        });

        window.onYouTubeIframeAPIReady = function() {
            _this.createVideo();
        }

        $(document).on('turbolinks:load', function() {
            $('video').bind('contextmenu',function() { return false; });
            if(YT.Player){
                _this.createVideo();
            }
        })

    },

    id: function() {
        return $('#video-container').data('id');
    },

    createVideo: function() {
        if($('#video-container').length > 0 && Users.count() > 0) {
            var _this = this;
            _this.setHeight();
            var player;

            player = new YT.Player('video', {
                videoId: _this.id(), // YouTube Video ID
                width: 300,               // Player width (in px)
                height: 150,              // Player height (in px)
                playerVars: {
                    autoplay: 1,        // Auto-play the video on load
                    controls: 1,        // Show pause/play buttons in player
                    showinfo: 0,        // Hide the video title
                    modestbranding: 1,  // Hide the Youtube Logo
                    loop: 1,            // Run the video in a loop
                    fs: 2,              // Hide the full screen button
                    cc_load_policy: 0,  // Hide closed captions
                    iv_load_policy: 3,  // Hide the Video Annotations
                    autohide: 0,         // Hide video controls when playing
                }
            });
        }
    },

    setHeight: function() {
        width = $('#video').width();
        height = parseInt((9*width)/16);
        $('#video').height(height);
    }

}

Video.initialize();

