import { Controller } from "stimulus"
import 'selectize/dist/js/selectize.min.js';

export default class extends Controller {
    connect() {
        // alert('a')
        $(this.element).selectize({
            valueField: 'english_name',
            labelField: 'language',
            searchField: 'language',
            create: false,
        });
    }
}
