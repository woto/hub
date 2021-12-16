import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.js';
import { useDispatch } from 'stimulus-use'
import * as bootstrap from "bootstrap";

export default class extends ApplicationController {
    static targets = [ 'entities' ]
    #selectize;
    #bootstrapWidgetsModal;

    itemRender(item, escape) {
        // TODO: js template
        let result = '';
        result += `            <div class='option'>`;
        result += `              <div class="d-flex">`;
        result += `                <div> <img src="${item.image.thumbnails['50']}" class="me-2"> </div>`;
        result += `                <div>`;
        result += `                    <div class="mb-1">`;
        result += `                        ${escape(item.title)}`;
        result += `                    </div>`;
        result += `                    <div>`;
        item.lookups.map(function (lookup) {
            result += `<div class="badge bg-azure mb-1 me-1">${escape(lookup)}</div>`
        }).join(' ');
        result += `                    </div>`
        result += `                    <div>`
        item.topics.map(function (topic) {
            result += `<div class="badge bg-cyan mb-1 me-1">${escape(topic)}</div>`
        }).join(' ');
        result += `                    </div>`;
        result += `                </div>`;
        result += `            </div>`;
        result += `        </div>`;
        return result;
    }

    connect() {
        useDispatch(this);
        const that = this;

        this.selectize = $(this.element).selectize({
            plugins: ["remove_button"],
            sortField: 'title',
            valueField: 'id',
            labelField: 'title',
            searchField: ['title', 'lookups'],
            load: function(query, callback) {
                this.clearOptions();
                if (!query.length) return callback();
                $.ajax({
                    url: '/api/mentions/entities',
                    type: 'GET',
                    data: {
                        q: query
                    },
                    success: function(res) {
                        callback(res);
                    }
                });
            },
            render: {
                item: function(item, escape) {
                    return that.itemRender(item, escape);
                },
                option: function(item, escape) {
                    return that.itemRender(item, escape);
                }
            },
            // score: function(search) {
            //     var score = this.getScoreFunction(search);
            //     return function(item) {
            //         return item.score + score(item);
            //         // return 1 + score(item);
            //     };
            // }
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
