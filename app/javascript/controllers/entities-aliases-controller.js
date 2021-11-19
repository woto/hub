import { Controller } from "stimulus"
import 'selectize/dist/js/selectize.min.js';

export default class extends Controller {
    #selectize;

    connect() {
        this.#selectize = $(this.element).selectize({
            plugins: ["remove_button"],
            delimiter: ',',
            sortField: 'title',
            valueField: 'title',
            labelField: 'title',
            searchField: 'title',
            create: function(input, callback){
                return callback({ title: input });
            },
        });
    }
}
