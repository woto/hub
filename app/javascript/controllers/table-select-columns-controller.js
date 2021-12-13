import { Controller } from "stimulus"
import 'selectize/dist/js/selectize.js';

export default class extends Controller {
    #selectize;

    connect() {
        this.selectize = $(this.element).selectize({
            plugins: ["remove_button"],
            delimiter: ','
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
