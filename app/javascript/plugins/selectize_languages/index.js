import 'selectize/dist/js/selectize.min.js';

document.addEventListener("DOMContentLoaded", function() {
    $('select.selectize-languages').selectize({
        // plugins: ['remove_button'],
        delimiter: ',',
        // persist: false,
        // create: function(input) {
        //     return {
        //         value: input,
        //         text: input
        //     }
        // }
    });
});
