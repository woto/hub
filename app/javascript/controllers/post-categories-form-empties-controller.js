import { Controller } from 'stimulus';
import { ApplicationController, useDispatch } from 'stimulus-use';
import 'selectize/dist/js/selectize.js';

export default class extends ApplicationController {
  #selectize;

  static values = { realmId: String, isDirty: Boolean };

  connect() {
    useDispatch(this);
    const that = this;

    this.selectize = $(this.element).selectize({
      valueField: 'id',
      labelField: 'title',
      searchField: 'title',
      create: false,
      render: {
        option(item, escape) {
          return '<div class=\'option\'>'
                                + `<div class='small'>${
                                  escape(item.path)
                                }</div>`
                                + `<div class='title'>${
                                  escape(item.title)
                                }</div>`
                            + '</div>';

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
        },
      },
      load(query, callback) {
        this.clearOptions();
        if (!query.length) return callback();
        $.ajax({
          url: '/api/posts/empty_categories',
          type: 'GET',
          data: {
            q: query,
            realm_id: that.realmIdValue,
          },
          success(res) {
            callback(res);
          },
        });
      },
      onChange() {
        const val = this.getValue();
        that.isDirtyValue = !!val;
      },
    });
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
