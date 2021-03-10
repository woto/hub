import { Controller } from "stimulus";
import Rails from "@rails/ujs";

export default class extends Controller {
    get modalSingleton() {
        return this.application.router.modulesByIdentifier.get('modal-singleton').contexts[0].controller;
    }

    open(event) {
        event.preventDefault();
        event.stopPropagation();

        // replace with jQuery
        Rails.ajax({
            url: this.data.get('url'),
            type: "get",
            dataType: 'json',
            success: (data) => {
                this.modalSingleton.open()
                    .then( () => {
                        this.modalSingleton.contentPlaceholderTarget.innerText = JSON.stringify(data);
                    });
            },
            error: function(data) { alert(data) }
        })
    }
}
