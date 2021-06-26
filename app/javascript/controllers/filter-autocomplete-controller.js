import { Controller } from "stimulus"
// TODO: remove
// import Rails from "@rails/ujs";
// import 'selectize/dist/js/selectize.min.js';

export default class extends Controller {
  connect() {
    let controller = this;
    $(this.element).selectize({
      valueField: 'title',
      labelField: 'title',
      searchField: 'title',
      options: [],
      create: false,
      // render: {
      //   option: function(item, escape) {
      //     debugger
      //     var actors = [];
      //     for (var i = 0, n = item.abridged_cast.length; i < n; i++) {
      //       actors.push('<span>' + escape(item.abridged_cast[i].name) + '</span>');
      //     }
      //
      //     return '<div>' +
      //         '<img src="' + escape(item.posters.thumbnail) + '" alt="">' +
      //         '<span class="title">' +
      //         '<span class="name">' + escape(item.title) + '</span>' +
      //         '</span>' +
      //         '<span class="description">' + escape(item.synopsis || 'No synopsis available at this time.') + '</span>' +
      //         '<span class="actors">' + (actors.length ? 'Starring ' + actors.join(', ') : 'Actors unavailable') + '</span>' +
      //         '</div>';
      //   }
      // },
      load: function(query, callback) {
        if (!query.length) return callback();
        $.ajax({
          url: controller.data.get('url'),
          type: "get",
          dataType: 'json',
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
    });

  }
}
