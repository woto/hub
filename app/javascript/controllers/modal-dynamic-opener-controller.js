import { Controller } from "stimulus";

export default class extends Controller {
    static values = { url: String}

    get modalSingleton() {
        return this.application.router.modulesByIdentifier.get('modal-singleton').contexts[0].controller;
    }

    open(event) {
        event.preventDefault();
        event.stopPropagation();

        $.get({
            url: this.urlValue,
            type: "get",
            success: (data) => {
                this.modalSingleton.open()
                    .then( () => {
                        this.modalSingleton.contentPlaceholderTarget.innerHTML = data;
                    });
            },
            error: function(data) { alert(data) }
        })
    }
}
