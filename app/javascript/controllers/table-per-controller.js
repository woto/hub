import { Controller } from "stimulus"

export default class extends Controller {
    visit(event) {
        let url = new URL(window.location.href);
        let params = new window.URLSearchParams(window.location.search);
        params.delete('page');
        params.set('per', event.currentTarget.value);
        url.search = params;
        window.location = url.toString();
    }
}
