import { Controller } from "stimulus"
import { Turbo, cable } from "@hotwired/turbo-rails"

export default class extends Controller {
    static targets = ["searchButton",  "searchText"]

    clickSearchButton(event) {
        if (event.keyCode == 13) {
            event.preventDefault();
            this.searchButtonTarget.focus();
            this.searchButtonTarget.click();
        }
    }

    searchEverywhere(event) {
        this._followLocation(this.data.get('everywhere-url'));
    }

    _followLocation(url) {
        url = new URL(url);
        url.searchParams.set('q', this.searchTextTarget.value)
        Turbo.visit(url.toString());
    }
}
