import { Controller } from "stimulus"
import Rails from "@rails/ujs";
import 'selectize/dist/js/selectize.min.js';

export default class extends Controller {
    connect() {
        $(this.element).selectize({
            delimiter: ',',
        });
    }
}
