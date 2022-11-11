import { Controller } from 'stimulus';
import { ApplicationController } from 'stimulus-use';
import 'selectize/dist/js/selectize.js';

export default class extends ApplicationController {
  #selectize;

  connect() {
    const that = this;

    this.selectize = $(this.element).selectize({
      valueField: 'id',
      labelField: 'email',
      searchField: 'email',
      create: false,
      load(query, callback) {
        this.clearOptions();
        if (!query.length) return callback();
        $.ajax({
          url: '/ajax/users',
          type: 'GET',
          error() {
            callback();
          },
          data: {
            q: query,
          },
          success(res) {
            callback(res);
          },
        });
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
}
