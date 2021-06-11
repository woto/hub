import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.min.js';

export default class extends ApplicationController {
    #selectize;

    connect() {
        const that = this;

        this.#selectize = $(this.element).selectize({
            valueField: 'id',
            labelField: 'email',
            searchField: 'email',
            create: false,
            load: function(query, callback) {
                this.clearOptions();
                if (!query.length) return callback();
                $.ajax({
                    url: '/ajax/users',
                    type: 'GET',
                    error: function() {
                        callback();
                    },
                    data: {
                        q: query
                    },
                    success: function(res) {
                        callback(res);
                    }
                });
            }
        });
    }
}
