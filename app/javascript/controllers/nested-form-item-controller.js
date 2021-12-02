import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
    static targets = ['destroy']
    static values = {
        new: Boolean
    }

    remove(event) {
        event.preventDefault();

        if (this.newValue) {
            this.element.remove();
        } else {
            this.element.classList.add('d-none')
            this.destroyTarget.value = 'true'
        }
    }
}
