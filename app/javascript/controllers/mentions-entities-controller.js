import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.js';
import { useDispatch } from 'stimulus-use'
import * as bootstrap from "bootstrap";

export default class extends ApplicationController {
    static targets = [ 'entities' ]
    #selectize;
    #bootstrapWidgetsModal;

    // onclick="window.open('/entities/${item.id}'); preventDefault()"

    entityLinkClick(event) {
        // alert('a');
        // event.preventDefault();
        // event.stopPropagation();
        // event.stopImmediatePropagation();
        window.open(event.params.url)
    }

    itemRender(item, escape) {
        return `<div class='option'>
                    <div class="d-flex">
                        <div> <img src="${item.image || ''}" class="me-1 width-100 max-height-300"> </div>
                        <div> 
                            <div class="ms-1">
                                <a href="#" 
                                    data-action="click->mentions-entities#entityLinkClick" 
                                    data-mentions-entities-url-param="/entities/${item.id}"> 
                                    ${escape(item.title)}
                                </a>
                            </div>
                            <div>
                                ${item.aliases.map(function (alias) {
                                    return `<span class="badge bg-blue-lt mb-1">${escape(alias)}</span>`
                                }).join(' ')}
                            </div>
                        </div>
                    </div>
                </div>`;
    }

    connect() {
        useDispatch(this);
        const that = this;

        this.#selectize = $(this.entitiesTarget).selectize({
            plugins: ["remove_button"],
            sortField: 'title',
            valueField: 'id',
            labelField: 'title',
            searchField: ['title', 'aliases'],
            // create: function(input, callback){
            //     // alert('pause');
            //     return callback({ title: input, id: '1', aliases: [], picture: '' });
            // },

            // create: function(input, callback) {
            //     console.log('a');
            //     $.get({
            //         headers: {
            //             Accept: "application/json"
            //         },
            //         url: 'http://localhost.lvh.me:3000/temporaries',
            //         type: "get",
            //         success: (data) => {
            //             that.modalPlaceholderTarget.innerHTML = data.content;
            //             const modal = that.modalPlaceholderTarget.firstElementChild
            //             that.#bootstrapWidgetsModal = new bootstrap.Modal(modal);
            //             that.#bootstrapWidgetsModal.show();
            //             return callback({ title: input, id: '1', aliases: [], picture: '' });
            //         },
            //         error: (jqXHR, textStatus, errorThrown) => {
            //             that.dispatch('showToast', {detail: {title: textStatus, body: jqXHR.responseJSON.error}});
            //             // that.dispatch('showToast', {detail: {title: textStatus, body: errorThrown}});
            //         }
            //     })
            // },
            load: function(query, callback) {
                this.clearOptions();
                if (!query.length) return callback();
                $.ajax({
                    url: '/api/mentions/entities',
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
            },
            render: {
                item: function(item, escape) {
                    return that.itemRender(item, escape);
                },
                option: function(item, escape) {
                    return that.itemRender(item, escape);



                    //
                    //     "</div>" +
                    //     "</div>";

                    // return '<div>' +
                    //     '<span class="title">' +
                    //     '<span class="name"><i class="icon ' + (item.fork ? 'fork' : 'source') + '"></i>' + escape(item.name) + '</span>' +
                    //     '<span class="by">' + escape(item.username) + '</span>' +
                    //     '</span>' +
                    //     '<span class="description">' + escape(item.description) + '</span>' +
                    //     '<ul class="meta">' +
                    //     (item.language ? '<li class="language">' + escape(item.language) + '</li>' : '') +
                    //     '<li class="watchers"><span>' + escape(item.watchers) + '</span> watchers</li>' +
                    //     '<li class="forks"><span>' + escape(item.forks) + '</span> forks</li>' +
                    //     '</ul>' +
                    //     '</div>';
                }
            },
            score: function(search) {
                var score = this.getScoreFunction(search);
                return function(item) {
                    return item.score + score(item);
                    // return 1 + score(item);
                };
            }
        })
    }
}
