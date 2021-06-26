import { Controller } from "stimulus"
import 'selectize/dist/js/selectize.min.js';

export default class extends Controller {
    #selectize;

    connect() {
        this.#selectize = $(this.element).selectize({
            delimiter: ',',
        });
    }
}
