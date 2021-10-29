import { Controller } from "stimulus"
import { ApplicationController } from 'stimulus-use'
import 'selectize/dist/js/selectize.min.js';

export default class extends ApplicationController {
    #selectize;

    connect() {
        this.#selectize = $(this.element).selectize({
            create: false
        })
    }
}
