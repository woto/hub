import { Controller } from "stimulus"
import 'selectize/dist/js/selectize.min.js';

export default class extends Controller {
    #selectize;

    initialize() {
        // console.log('profile-language-controller initialize');
    }

    connect() {
        // console.log('profile-language-controller connect');
        this.#selectize = $(this.element).selectize({
            delimiter: ',',
        });
    }
}
