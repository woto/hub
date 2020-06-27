import 'selectize/dist/js/selectize.min.js';

document.addEventListener("turbolinks:load", function() {
    $('select').selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        persist: false,
        create: function(input) {
            return {
                value: input,
                text: input
            }
        }
    });
});
