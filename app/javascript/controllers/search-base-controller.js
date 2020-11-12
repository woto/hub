import { Controller } from "stimulus"

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
        url.searchParams.append('q', this.searchTextTarget.value)
        window.location = url.toString();
    }
}
