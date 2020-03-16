var PageReloader = {

    timer: null,

    initialize: function() {

        var _this = this;


        $(document).on('turbolinks:load', function() {
            _this.onLoad();
        });

        $(document).on('turbolinks:click', function() {
            _this.clearTimer();
        });

    },

    onLoad: function(){
        var _this = this;
        _this.startTimer();
    },

    startTimer: function() {
        var _this = this;
        if($('.reload-page').length > 0) {
            _this.timer = setTimeout(function() {
                _this.reload_with_timer();
            }, 15000);
        }
    },

    reload_with_timer: function() {
        var _this = this;
        _this.reload();
        _this.startTimer();
    },

    reload: function() {
        Turbolinks.visit(location.toString());
    },

    clearTimer: function() {
        var _this = this;
        try { clearTimeout(_this.timer) } catch(e) { }
    }


}

PageReloader.initialize();