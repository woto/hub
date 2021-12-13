import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.js';
import { useDispatch } from 'stimulus-use'

export default class extends ApplicationController {
    #selectize;
    static values = { realmId: String, isDirty: Boolean }

    connect() {
        useDispatch(this);
        const that = this;

        this.selectize = $(this.element).selectize({
            plugins: ["remove_button", "restore_on_backspace"],
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
                    url: '/api/posts/tags',
                    type: 'GET',
                    data: {
                        q: query,
                        realm_id: that.realmIdValue
                    },
                    success: function(res) {
                        callback(res);
                    }
                });
            },
            onChange() {
                const val = this.getValue();
                that.isDirtyValue = val.length > 0
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

    isDirtyValueChanged() {
        const that = this;
        this.dispatch('setDirty', { isDirty: that.isDirtyValue });
    }


    postRealmIdChange(event) {
        this.realmIdValue = event.detail.realmId;

        this.#selectize[0].selectize.setValue();
        this.#selectize[0].selectize.clearOptions(true);
    }
}
