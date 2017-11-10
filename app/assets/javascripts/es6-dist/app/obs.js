const obs = new OBSWebSocket();

obs.onConnectionOpened(() => {
    OBSWrapper.generateLayout();
});

obs.onConnectionClosed(() => {
    OBSWrapper.connect();
});

obs.onSwitchScenes(data => {
    $('.obs-scene-switch').removeClass('btn-danger');
    $('.obs-scene-switch[data-scene-name="' + data.sceneName + '"]').addClass('btn-danger');
    $('.obs-scene-switch').removeClass('disabled');
});

obs.onStreamStarted(data => {
    $('.streaming-info').removeClass('text-default').addClass('text-success').html('ON');
});

obs.onStreamStopped(data => {
    $('.streaming-info').removeClass('text-success').addClass('text-default').html('OFF');
});

var OBSWrapper = {

    initialize: function () {

        var _this = this;

        $(document).on('click', '.obs-scene-switch', function (e) {

            e.preventDefault();

            var caller = $(this);

            $('.obs-scene-switch').addClass('disabled');

            obs.setCurrentScene({
                'scene-name': caller.data('scene-name')
            }).catch(err => {
                $('.obs-scene-switch').removeClass('disabled');
            });
        });

        $(document).on('turbolinks:load', function () {
            if ($('#obs-section').length > 0) {
                if (!OBSWrapper.connectTriggered) {
                    _this.connect();
                } else {
                    OBSWrapper.generateLayout();
                }
            }
        });
    },

    connectTriggered: false,

    connect: function () {
        var _this = this;

        obs.connect({ address: 'localhost:4444' }).catch(err => {
            _this.resetContent();
        });

        _this.connectTriggered = true;
    },

    resetContent: function () {
        $('#obs-section').html(this.generateOBSisDisabledInfoHtml());
    },

    generateLayout: function () {
        const obs_section = $('#obs-section');
        obs_section.html('');

        obs.getSceneList().then(data => {
            data.scenes.forEach(scene => {
                obs_section.append(OBSWrapper.generateButtonSceneHtml(scene, data.currentScene));
            });
        });

        obs.getStreamingStatus().then(data => {
            obs_section.append(OBSWrapper.generateStreamingInfoHtml(data.streaming));
        });
    },

    generateButtonSceneHtml: function (scene, activeScene) {
        html = '<a class="btn obs-scene-switch btn-xs btn-default ' + (scene.name == activeScene ? 'btn-danger' : '') + '" data-scene-name="' + scene.name + '">' + scene.name + '</a>';
        return html;
    },

    generateStreamingInfoHtml: function (status) {
        html = '<span class="streaming-status"><span class="streaming-label">OBS Streaming: </span><span class="streaming-info ' + (status ? 'text-success' : 'text-default') + '">' + (status ? 'ON' : 'OFF') + '</span></span>';
        return html;
    },

    generateOBSisDisabledInfoHtml: function () {
        html = '<span>OBS jest wyłączony.</span>';
        return html;
    }

};

OBSWrapper.initialize();