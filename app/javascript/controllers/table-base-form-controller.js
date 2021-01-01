import { Controller } from "stimulus"

export default class extends Controller {
    static targets = [ "form" ]

    connect() {}

    toggleForm(event) {
        event.preventDefault();

        let isDisplayed = this.data.get('isDisplayed')
        if(isDisplayed == '1') {
            this.hideForm();
            this.data.set('isDisplayed', '0');
        } else {
            this.displayForm();
            this.data.set('isDisplayed', '1');
        }
    }

    displayForm() {
        this.formTarget.classList.add('d-block');
        this.formTarget.classList.remove('d-none');
    }

    hideForm() {
        this.formTarget.classList.add('d-none');
        this.formTarget.classList.remove('d-block');
    }
}

