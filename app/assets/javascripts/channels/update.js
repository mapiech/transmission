App.update = App.cable.subscriptions.create('UpdateChannel', {

    received: function(data) {
      console.debug(data)
      $('body').html('ok')
    }

});