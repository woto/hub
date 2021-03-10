import { Controller } from "stimulus"

export default class extends Controller {
    get modalSingleton() {
        return this.application.router.modulesByIdentifier.get('modal-singleton').contexts[0].controller;
    }

    open(event) {
        event.preventDefault();
        event.stopPropagation();

        let text = this.data.get('text');
        this.modalSingleton.open()
            .then( () => {
                this.modalSingleton.contentPlaceholderTarget.innerText = text;
            });
    }
}
