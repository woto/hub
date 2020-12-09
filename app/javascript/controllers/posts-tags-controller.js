import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.min.js';

export default class extends ApplicationController {
    #selectize;

    connect() {
        const that = this;
        this.#selectize = $(this.element).selectize({
            sortField: 'title',
            valueField: 'title',
            labelField: 'title',
            searchField: 'title',
            create: function(input, callback){
                // addItem()
                return callback({ title: input });
            },
            load: function(query, callback) {
                if (!query.length) return callback();
                $.ajax({
                    url: '/ajax/tags',
                    type: 'GET',
                    data: {
                        q: query,
                        realm_id: that.data.get('realmId')
                    },
                    error: function() {
                        callback();
                    },
                    success: function(res) {
                        console.log(res);
                        callback(res);
                    }
                });
            }
        })
    }

    clearBecauseRealmIdChanged() {
        this.#selectize[0].selectize.setValue();
        this.#selectize[0].selectize.clearOptions(true);
    }
}
