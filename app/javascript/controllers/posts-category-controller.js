import { Controller } from "stimulus"
import 'selectize/dist/js/selectize.min.js';

export default class extends Controller {
    connect() {
        $(this.element).selectize({
            valueField: 'id',
            labelField: 'title',
            searchField: 'title',
            create: false,
            render: {
                option: function(item, escape) {
                    return "<div class='option'>" +
                                "<div class='small'>" +
                                    escape(item.path) +
                                "</div>" +
                                "<div class='title'>" +
                                    escape(item.title) +
                                "</div>" +
                            "</div>";

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
            load: function(query, callback) {
                this.clearOptions();
                if (!query.length) return callback();
                $.ajax({
                    url: '/categories/?q=' + encodeURIComponent(query),
                    type: 'GET',
                    error: function() {
                        callback();
                    },
                    success: function(res) {
                        console.log(res);
                        callback(res);
                    }
                });
            }
        });
    }
}
