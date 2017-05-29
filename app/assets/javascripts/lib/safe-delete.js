var SafeDelete = {

    initialize: function(){

        $(document).on('click', '.safe-delete', function(e){
            e.preventDefault();

            invoker = $(this);

            modal = $('#safe-delete-modal');
            delete_link = modal.find('.real-delete');
            delete_link.show();
            delete_text_info = modal.find('.delete-item-info');

            delete_link.attr('href', invoker.attr('href'));

            if(typeof(invoker.data('confirm-remote')) != 'undefined') {
                delete_link.data('remote', true);
            } else {
                delete_link.removeData('remote');
            }

            delete_text_info.html(invoker.data('delete-text-info'));
            modal.modal('show');

        });

        $(document).on('click', '.real-delete', function(e) {
            $('#safe-delete-modal').modal('hide');
        });

    }


}

SafeDelete.initialize();