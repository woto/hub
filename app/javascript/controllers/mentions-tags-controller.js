import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.min.js';
import { useDispatch } from 'stimulus-use'

export default class extends ApplicationController {
    #selectize;

    connect() {
        useDispatch(this);
        const that = this;

        this.#selectize = $(this.element).selectize({
            plugins: ["remove_button"],
            sortField: 'title',
            valueField: 'title',
            labelField: 'title',
            searchField: 'title',
            create: function(input, callback){
                return callback({ title: input });
            },
            load: function(query, callback) {
                if (!query.length) return callback();
                $.ajax({
                    url: '/api/mentions/tags',
                    type: 'GET',
                    data: {
                        q: query
                    },
                    error: function() {
                        callback();
                    },
                    success: function(res) {
                        callback(res);
                    }
                });
            }
        })
    }
}
