import { Controller } from "stimulus"

export default class extends Controller {
    removeEntity(event) {
        event.preventDefault();
        this.element.remove();
    }
}