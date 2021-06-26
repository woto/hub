import { Controller } from "stimulus"
import { Turbo, cable } from "@hotwired/turbo-rails"

export default class extends Controller {
    initialize() {
        const that = this;
        setTimeout(() => {
            that.element.value = that.data.get('select-value')
        }, 0);
    }

    visit(event) {
        let url = new URL(window.location.href);
        let params = new window.URLSearchParams(window.location.search);
        params.delete('page');
        params.set('per', event.currentTarget.value);
        url.search = params;
        Turbo.visit(url.toString());
    }
}
