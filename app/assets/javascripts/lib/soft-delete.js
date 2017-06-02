var SoftDelete = {

    currentInvoker: false,

    initialize: function(){

        var _this = this;

        $(document).on('click', '.soft-delete', function(e){
            e.preventDefault();

            invoker = $(this);
            _this.currentInvoker = invoker;

            modal = $('#soft-delete-modal');

            message_text = invoker.data('message');
            message = modal.find('.message');
            message.html(message_text);

            delete_link = modal.find('.real-delete');
            delete_link.attr('href', invoker.attr('href'));
            if(invoker.hasClass('soft-delete-remote')) {
                delete_link.attr("data-remote", 'true');
            } else {
                delete_link.removeData('remote');
            }

            modal.modal('show');

        });

        $(document).on('ajax:beforeSend', '.real-delete', function(event, xhr, settings) {

            modal = $('#soft-delete-modal');

            modal.data('bs.modal').options.backdrop = 'static';
            modal.find('button.close').hide();

            delete_link = modal.find('.real-delete');
            delete_link.addClass('disabled');
            delete_link.html(delete_link.data('sending-text'));
        });

        $(document).on('ajax:success', '.real-delete', function(event, data, xhr, status) {

        });

        $(document).on('ajax:complete', '.real-delete', function(event, xhr, status) {

            modal.modal('hide');

            modal = $('#soft-delete-modal');
            modal.data('bs.modal').options.backdrop = true;

            modal.find('button.close').show();

            delete_link = modal.find('.real-delete');
            delete_link.removeClass('disabled');
            delete_link.html(delete_link.data('link-text'));

        });

    }


}

SoftDelete.initialize();