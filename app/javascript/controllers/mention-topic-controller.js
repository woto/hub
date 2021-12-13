import {Controller} from "stimulus"
import {ApplicationController} from 'stimulus-use'
import 'selectize/dist/js/selectize.js';
import {useDispatch} from 'stimulus-use'
export default class extends ApplicationController {
    static values = {
        placeholder: String
    }
    #selectize;

    connect() {
        useDispatch(this);
        const that = this;

        this.selectize = $(this.element).selectize({
            plugins: ["remove_button", "restore_on_backspace"],
            sortField: 'title',
            valueField: 'title',
            labelField: 'title',
            searchField: 'title',
            placeholder: that.placeholderValue,
            create: function (input, callback) {
                return callback({title: input});
            },
            load: function (query, callback) {
                if (!query.length) return callback();
                $.ajax({
                    url: '/api/mentions/topics',
                    type: 'GET',
                    data: {
                        q: query
                    },
                    success: function (res) {
                        callback(res);
                    }
                });
            }
        })
    }

    disconnect() {
        this.selectize.destroy();
    }

    get selectize() {
        return this.#selectize[0].selectize;
    }

    set selectize(value) {
        this.#selectize = value;
    }
}
