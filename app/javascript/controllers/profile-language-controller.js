import { Controller } from "stimulus"
import 'selectize/dist/js/selectize.min.js';

export default class extends Controller {
    #selectize;

    initialize() {
        console.log('profile-language-controller initialize');
    }

    connect() {
        console.log('profile-language-controller connect');
        this.#selectize = $(this.element).selectize({
            delimiter: ',',
        });
    }

    disconnect() {
        console.log('profile-language-controller disconnect');
        if(this.selectize) {
            this.selectize.destroy();
        }
    }

    teardown() {
        console.log('profile-language-controller teardown');
        if(this.selectize) {
            this.selectize.destroy();
        }
    }

    // TODO: maybe not needed
    get selectize() {
        return this.#selectize && this.#selectize.length > 0 && this.#selectize[0].selectize
    }
}
