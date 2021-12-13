import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.js';

export default class extends ApplicationController {
    #selectize;

    connect() {
        this.selectize = $(this.element).selectize({
            create: false
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
