var CheckboxArea = {

    initialize: function() {

        $(document).on('change', '.checkbox-bind-area', function(e) {
           checkbox = $(this);
           area = $(checkbox.data('bind-area'));
           checkbox.is(':checked') ? area.show() : area.hide()
        });

        $(document).on('turbolinks:load', function() {
           $('.checkbox-bind-area').trigger('change');
        });

    }

}
CheckboxArea.initialize();