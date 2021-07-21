import { Controller } from "stimulus"

export default class extends Controller {
    static targets = [ "form", 'toggleButton' ]

    connect() {}

    toggleForm(event) {
        event.preventDefault();

        let isDisplayed = this.data.get('isDisplayed')
        if(isDisplayed === '1') {
            this.hideForm();
            this.buttonOff();
            this.data.set('isDisplayed', '0');
        } else {
            this.displayForm();
            this.buttonOn();
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

    buttonOn() {
        this.toggleButtonTarget.classList.add('btn-info');
        this.toggleButtonTarget.classList.remove('btn-primary');
    }

    buttonOff() {
        this.toggleButtonTarget.classList.add('btn-primary');
        this.toggleButtonTarget.classList.remove('btn-info');
    }
}

