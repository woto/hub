import { ApplicationController } from 'stimulus-use'

export default class extends ApplicationController {
    static targets = [ "searchText" ]

    clear(event) {
        event.preventDefault();
        this.searchTextTarget.value = '';
        this.searchTextTarget.focus();
    }
}
