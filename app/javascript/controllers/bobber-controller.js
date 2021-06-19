import { Controller } from "stimulus"

export default class extends Controller {
    increaseZIndex() {
        this.element.classList.add('z-index-increased');
        this.element.classList.remove('z-index-decreased');
    }

    decreaseZIndex() {
        this.element.classList.add('z-index-decreased');
        this.element.classList.remove('z-index-increased');
    }
}
